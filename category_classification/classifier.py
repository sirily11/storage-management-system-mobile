import shutil
from tkinter import *
from tkinter.ttk import *
import requests
import cv2
import os
import tensorflow as tf
import numpy as np
import tensorflow as tf
from tensorflow.keras.layers import Dense, Conv2D, Flatten
import glob

BASE_URL = "http://192.168.31.19:8080/storage_management"
CATEGORY = "category/"
ITEM_IMAGES = "item-image/"
WIDTH = 224
HEIGHT = 224


class ClassifierCallback(tf.keras.callbacks.Callback):

    def __init__(self, callback):
        super().__init__()
        self.callback = callback

    def on_train_begin(self, logs=None):
        if self.callback:
            self.callback("start")

    def on_epoch_end(self, epoch, logs=None):
        if self.callback:
            self.callback("progress", epoch, logs['loss'], logs['acc'])

    def on_train_end(self, logs=None):
        if self.callback:
            self.callback("end")
    # def on_test_batch_begin(self, batch, logs=None):
    #     print('Evaluating: batch {} begins at {}'.format(batch, datetime.datetime.now().time()))
    #
    # def on_test_batch_end(self, batch, logs=None):
    #     print('Evaluating: batch {} ends at {}'.format(batch, datetime.datetime.now().time()))


class Classifier:
    images: list
    model: tf.keras.Model

    def __init__(self):
        self.categories: [] = requests.get(f"{BASE_URL}/{CATEGORY}").json()
        self.item_images = requests.get(f"{BASE_URL}/{ITEM_IMAGES}").json()

        self.graph = tf.get_default_graph()
        self.session = tf.Session()

        self.num_categories = len(self.categories)
        self.image_urls = [i['image'] for i in self.item_images]
        self.labels = np.asarray([i['category']['id'] - 1 for i in self.item_images])
        self.image_paths = [os.path.basename(i['image']) for i in self.item_images]
        self.images = []
        self.model = None

    def download_image(self, callback=None):
        """
        Download image from internet.
        Call this method before the load image if you didn't download the image before.
        :return:
        """
        for i, url in enumerate(self.image_urls):
            res = requests.get(url, stream=True)
            path = os.path.join(os.getcwd(), f"images/{os.path.basename(url)}")
            with open(path, "wb") as out_file:
                shutil.copyfileobj(res.raw, out_file)
            del res
            if callback:
                callback("Download image", i, len(self.image_urls))
        return self

    def load_images(self, callback=None):
        """
        Load image from local folder to memory
        :return:
        """
        if len(glob.glob("images/*")) == 0:
            self.download_image(callback)
        images = []
        for i, path in enumerate(self.image_paths):
            path = os.path.join(f"images/{path}")
            image = tf.keras.preprocessing.image.load_img(path, target_size=(WIDTH, HEIGHT))
            image = tf.keras.preprocessing.image.img_to_array(image)
            image = tf.keras.applications.vgg19.preprocess_input(image)
            images.append(image)
            if callback:
                callback("Loading image", i, len(self.image_paths))
        self.images = np.asarray(images)
        return self

    def build_model(self, callback=None):
        """
        Build model and then compile the model
        :return:
        """
        with self.graph.as_default():
            with self.session.as_default():
                if not self.model:
                    base_model = tf.keras.applications.VGG19(weights='imagenet',
                                                             include_top=False,
                                                             input_shape=(WIDTH, HEIGHT, 3))
                    base_model.trainable = False
                    self.model = tf.keras.Sequential([base_model, tf.keras.layers.GlobalAveragePooling2D()])
                    self.model.add(Dense(self.num_categories, activation="softmax"))
                    self.model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
                if callback:
                    callback("build")
                return self

    def train(self, epochs=5, callback=None):
        """
        Train the model
        :param callback:
        :param epochs: how many epochs you want to train
        :return:
        """
        with self.graph.as_default():
            with self.session.as_default():
                assert len(self.images) > 0
                assert len(self.labels) > 0
                if not self.model:
                    self.build_model(callback)
                self.model.fit(self.images, self.labels,
                               epochs=epochs,
                               callbacks=[ClassifierCallback(callback=callback)],
                               verbose=0)
                return self

    def predict(self, image: str, callback=None) -> dict:
        """
        Make prediction
        :param image: image path
        :return: name of the prediction, id, and acc
        """
        with self.graph.as_default():
            with self.session.as_default():
                test_image = cv2.imread(image)
                test_image = cv2.resize(test_image, (WIDTH, HEIGHT))
                pre = self.model.predict(test_image.reshape(1, WIDTH, HEIGHT, 3))[0]
                index = np.argmax(pre) + 1
                name = self._get_category_name(index)
                if callback:
                    callback({"name": name, "id": index, "acc": pre[index - 1]})
                return {"name": name, "id": index, "acc": pre[index - 1]}

    def save(self):
        with self.graph.as_default():
            with self.session.as_default():
                self.model.save("my_classifier.h5")

    def load(self):
        with self.graph.as_default():
            with self.session.as_default():
                self.model = tf.keras.models.load_model("my_classifier.h5")

    def _get_category_name(self, cid: int) -> str:
        for c in self.categories:
            if c['id'] == cid:
                return c['name']

# classifier = Classifier()
# print(classifier.load_images().build_model().train(epochs=2).predict(image="/Users/liqiwei/Desktop/屏幕快照 2019-07-17 上午1.39.20.png"))
