import os
os.environ['CUDA_VISIBLE_DEVICES'] = ''

import signal
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, GlobalAveragePooling2D, Dense
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import CategoricalCrossentropy
from tensorflow.keras.metrics import CategoricalAccuracy
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

# Function to export the current model to TensorFlow Lite
def export_to_tflite(model, tflite_filename):
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    tflite_model = converter.convert()
    with open(tflite_filename, 'wb') as f:
        f.write(tflite_model)
    print("Model exported to", tflite_filename)

# Define the path to your dataset (each subfolder is a food category)
data_dir = './dataset'

# Define the data generator
batch_size = 32
data_generator = ImageDataGenerator(
    preprocessing_function=preprocess_input,
    validation_split=0.2  # You can adjust the validation split
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

# Add a custom head for classification
x = GlobalAveragePooling2D()(base_model.output)
x = Dense(train_data.num_classes, activation='softmax')(x)

# Create the model
model = Model(inputs=base_model.input, outputs=x)

# Compile the model
model.compile(optimizer=Adam(learning_rate=0.001),
              loss=CategoricalCrossentropy(from_logits=True),
              metrics=[CategoricalAccuracy()])

# Define a ModelCheckpoint callback to save the best model
model_checkpoint = ModelCheckpoint("best_model.h5", monitor='val_categorical_accuracy', save_best_only=True)

# Interrupt signal handler to export the model on keyboard interrupt
def handle_interrupt(signum, frame):
    export_to_tflite(model, 'interrupted_model.tflite')
    exit(0)

# Set up the interrupt signal handler
signal.signal(signal.SIGINT, handle_interrupt)

# Train the model
early_stopping = EarlyStopping(monitor='val_categorical_accuracy', patience=10, restore_best_weights=True)
model.fit(train_data, validation_data=validation_data, epochs=100, callbacks=[early_stopping, model_checkpoint])
