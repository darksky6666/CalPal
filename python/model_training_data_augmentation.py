import os
# os.environ['CUDA_VISIBLE_DEVICES'] = ''
os.environ['TF_FORCE_GPU_ALLOW_GROWTH'] = 'true'

import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, GlobalAveragePooling2D, Dense, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import CategoricalCrossentropy
from tensorflow.keras.metrics import CategoricalAccuracy
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from tensorflow.keras.callbacks import EarlyStopping, LambdaCallback, ModelCheckpoint, LearningRateScheduler
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# Define the path to your dataset (each subfolder is a food category)
data_dir = './dataset'

# Define the data generator with data augmentation
batch_size = 20
data_generator = ImageDataGenerator(
    preprocessing_function=preprocess_input,
    validation_split=0.2,
    rotation_range=40,  # Rotate images
    width_shift_range=0.2,  # Shift width
    height_shift_range=0.2,  # Shift height
    shear_range=0.2,  # Shear transformations
    zoom_range=0.2,  # Zoom in/out
    horizontal_flip=True,  # Flip horizontally
    fill_mode='nearest'  # Fill missing pixels
)

train_data = data_generator.flow_from_directory(
    data_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical',
    subset='training'
)

validation_data = data_generator.flow_from_directory(
    data_dir,
    target_size=(224, 224),
    batch_size=batch_size,
    class_mode='categorical',
    subset='validation'
)

# Define the base MobileNetV2 model
base_model = MobileNetV2(input_shape=(224, 224, 3), include_top=False, weights='imagenet')

# Fine-tune the base model
for layer in base_model.layers:
    layer.trainable = True

# Add a custom head for classification with dropout
x = GlobalAveragePooling2D()(base_model.output)
x = Dropout(0.5)(x)  # Add dropout
x = Dense(train_data.num_classes, activation='softmax')(x)

# Create the model
model = Model(inputs=base_model.input, outputs=x)

# Check if there are any existing checkpoints
if os.path.exists('best_model.h5'):
    # Load the best checkpointed model
    model.load_weights('best_model.h5')
    print("Resuming training from the best checkpointed model.")
    resume_training = True
else:
    # Start a new training session
    resume_training = False

# Use an aggressive learning rate schedule
initial_learning_rate = 0.01
lr_schedule = LearningRateScheduler(lambda epoch: initial_learning_rate / (10 ** (epoch // 5)))
model.compile(optimizer=Adam(learning_rate=initial_learning_rate),
              loss=CategoricalCrossentropy(from_logits=True),
              metrics=[CategoricalAccuracy()])

# Define a LambdaCallback to print accuracy during training
print_accuracy = LambdaCallback(on_epoch_end=lambda epoch, logs: print(f"Epoch {epoch + 1}, Val Acc: {logs['val_categorical_accuracy']}"))

# Define model checkpoint to save the best model weights
model_checkpoint = ModelCheckpoint('best_model.h5', save_best_only=True, monitor='val_categorical_accuracy', mode='max', verbose=1)

# Train the model with learning rate scheduling and checkpointing
early_stopping = EarlyStopping(monitor='val_categorical_accuracy', patience=10, restore_best_weights=True)

try:
    if resume_training:
        # If resuming training, the initial_epoch is set to the last trained epoch
        model.fit(train_data, validation_data=validation_data, epochs=100, callbacks=[early_stopping, print_accuracy, lr_schedule, model_checkpoint], initial_epoch=model.optimizer.iterations.numpy() // (train_data.samples // batch_size))
    else:
        model.fit(train_data, validation_data=validation_data, epochs=100, callbacks=[early_stopping, print_accuracy, lr_schedule, model_checkpoint])
except KeyboardInterrupt:
    print("Keyboard interrupt detected. Saving checkpoint and exporting to TFLite.")
    model.save_weights('interrupted_model.h5')

# Export the model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()
with open('food_classifier.tflite', 'wb') as f:
    f.write(tflite_model)
