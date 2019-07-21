import tkinter as tk
from tkinter import *
from tkinter import Frame, Button, Text, Label, Entry
from tkinter.ttk import Frame, Label, Progressbar, Entry, Button, Separator
from typing import Union
import threading
from tkinter.filedialog import askopenfilename
from PIL import Image, ImageTk

from classifier import Classifier


class Application(tk.Frame):
    load_model_btn: Button
    save_model_btn: Button
    image: Union[Label, Label]
    name: str
    acc: Union[Label, Label]
    loss: Union[Label, Label]
    current_epochs: Union[Label, Label]
    open_dialog_btn: Union[Button, Button]
    predict_frame: Union[Frame, Frame]
    train_epochs: Union[Entry, Entry]
    train_frame: Union[Frame, Frame]
    predict_btn: Button
    train_btn: Button
    progress_bar: Progressbar
    info_label: Union[Label, Label]
    num_images: Union[Label, Label]
    num_categories: Union[Label, Label]
    info_frame: Union[Frame, Frame]
    display: Text
    download_image_btn: Button
    left_frame: Frame

    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.classifier = Classifier()

        self.left_frame = Frame(master, style="My.TFrame")
        self.left_frame.pack(side=LEFT, fill=BOTH, )

        # Separator(master, orient=VERTICAL).grid(column=1, row=0, sticky='ns')

        self.right_frame = Frame(master)
        self.right_frame.pack(side=RIGHT, fill=BOTH, padx=10)

        self.create_left()
        self.create_right()

    def create_left(self):
        self.create_download_frame()
        self.create_train_frame()
        self.create_predict_frame()
        self.create_info_frame()

    def create_info_frame(self):
        self.info_frame = Frame(self.left_frame)
        self.info_frame.pack()

        info_num_categories = Label(self.info_frame, text="Number of categories:")
        info_num_categories.grid(column=0, row=0, sticky=W)
        self.num_categories = Label(self.info_frame, text=self.classifier.num_categories)
        self.num_categories.grid(column=1, row=0)

        info_num_images = Label(self.info_frame, text="Number of images:")
        info_num_images.grid(column=0, row=1, sticky=W)
        self.num_images = Label(self.info_frame, text=len(self.classifier.image_paths))
        self.num_images.grid(column=1, row=1)

        # ==== Training ====
        label = Label(self.info_frame, text="Epochs:")
        label.grid(column=0, row=2, sticky=W)
        self.current_epochs = Label(self.info_frame, text=0)
        self.current_epochs.grid(column=1, row=2)

        label = Label(self.info_frame, text="Acc:")
        label.grid(column=0, row=3, sticky=W)
        self.acc = Label(self.info_frame, text=0)
        self.acc.grid(column=1, row=3)

        label = Label(self.info_frame, text="Loss:")
        label.grid(column=0, row=4, sticky=W)
        self.loss = Label(self.info_frame, text=0)
        self.loss.grid(column=1, row=4)

        Separator(self.info_frame).grid(row=5, sticky="ew", padx=4)

        self.info_label = Label(self.left_frame)
        self.info_label.pack(fill=X)
        self.progress_bar = Progressbar(self.left_frame, length=200, mode="determinate", orient=HORIZONTAL)
        self.progress_bar.pack(fill=X)
        self.image = Label(self.left_frame)
        self.image.pack(fill=X)

    def create_download_frame(self):
        self.winfo_toplevel().title("Trainer")
        self.download_image_btn = tk.Button(self.left_frame, text="Download Images", command=self.download)
        self.download_image_btn.pack(fill=X, pady=(20, 10))
        self.save_model_btn = tk.Button(self.left_frame, text="Save Model", command=self.save, state=DISABLED)
        self.save_model_btn.pack(fill=X, pady=(20, 10))
        self.load_model_btn = tk.Button(self.left_frame, text="Load Model", command=self.load)
        self.load_model_btn.pack(fill=X, pady=(20, 10))

    def create_predict_frame(self):
        self.predict_frame = Frame(self.left_frame)
        self.predict_frame.pack(fill=X, pady=(20, 10))
        self.open_dialog_btn = Button(self.predict_frame, text="Open File", command=self.openfile, state=DISABLED)
        self.open_dialog_btn.grid(column=0, row=0)
        self.predict_btn = tk.Button(self.predict_frame, text="Predict", command=self.predict, state=DISABLED)
        self.predict_btn.grid(column=1, row=0, padx=5, sticky='ew', columnspan=2)

    def create_train_frame(self):
        self.train_frame = Frame(self.left_frame)
        self.train_frame.pack(fill=X, pady=(20, 10))
        label = Label(self.train_frame, text="Epochs:")
        label.grid(column=1, row=0)
        self.train_epochs = Entry(self.train_frame, width=6)
        self.train_epochs.grid(column=2, row=0)
        self.train_btn = tk.Button(self.train_frame, text="Train", command=self.train, state=DISABLED)
        self.train_btn.grid(column=3, row=0, columnspan=2, padx=5)

    def create_right(self):
        self.display = tk.Text(self.right_frame)
        self.display.pack(expand=True, fill=BOTH)

    def openfile(self):
        name = askopenfilename(filetypes=(("JPG File", "*.jpg"),
                                          ("PNG File", "*.png"),
                                          ("BMP File", "*.bmp"),
                                          ("All Files", "*.*")),
                               title="Choose a file."
                               )
        if name and self.classifier.model:
            self.predict_btn.config(state=ACTIVE)
            self.name = name

    def download(self):
        t = threading.Thread(target=self.classifier.load_images, args=(self.download_callback,))
        t.start()

    def predict(self):
        t = threading.Thread(target=self.classifier.predict, args=(self.name, self.predict_callback,))
        t.start()

    def train(self):
        epoch = self.train_epochs.get()
        if epoch is not None and epoch != "":
            for e in epoch:
                if e not in "0123456789":
                    raise ValueError("Value error")
            t = threading.Thread(target=self.classifier.train, args=(int(epoch), self.train_callback))
            t.start()
            self.train_btn.config(state=DISABLED)
        else:
            self.display.insert(END, "Epoch value error\n")

    def save(self):
        self.classifier.save()
        self.display.insert(END, "Model has been saved\n")

    def load(self):
        self.classifier.load()
        self.display.insert(END, "Model has been loaded\n")

    def train_callback(self, state: str, epoch: int = 0, loss: float = 0, acc: float = 0):
        if state == "start":
            self.display.insert(END, "Start training\n")
            self.info_label.config(text="Start training")

        elif state == "progress":
            total_epoch = int(self.train_epochs.get())
            progress = ((epoch + 1) / total_epoch) * 100
            self.progress_bar['value'] = progress
            self.current_epochs.config(text=epoch + 1)
            self.acc.config(text='{:.2f}%'.format(100 * acc))
            self.loss.config(text=round(loss, 3))
            self.display.insert(END, f"Started training on epoch {epoch}\n")

        elif state == "end":
            self.display.insert(END, "Finished training\n")
            self.info_label.config(text="Finished training")
            self.train_btn.config(state=ACTIVE)
            self.save_model_btn.config(state=ACTIVE)
            self.open_dialog_btn.config(state=ACTIVE)

    def predict_callback(self, data: dict):
        self.display.insert(END, "=====================\n")
        print(self.name)
        image1 = Image.open(self.name)
        image1.thumbnail((200, 200), Image.ANTIALIAS)
        photo_img = ImageTk.PhotoImage(image1)
        self.image.config(image=photo_img)
        self.image.image = photo_img
        self.display.insert(END, f"Prediction: {data['id']} {data['name']} {round(100 * data['acc'], 4)} %\n",
                            ('important',))
        self.display.insert(END, "=====================\n")

    def download_callback(self, label, num_completed, total):
        self.info_label.config(text=f"Processing {label}")
        progress = ((num_completed + 1) / total) * 100
        self.progress_bar['value'] = progress
        if progress == 100:
            self.display.insert(END, f"{label} finished\n")
            self.info_label.config(text=f"{label} finished")
            self.train_btn.config(state=ACTIVE)


root = tk.Tk()
root.geometry("500x700")
app = Application(master=root)
app.mainloop()
