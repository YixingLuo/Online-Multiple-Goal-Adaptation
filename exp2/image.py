import cv2 as cv
import numpy as np


def create_image():
    img = np.zeros([1920, 1080 , 3], np.uint8)
    img[:, :, 0] = np.zeros([1920, 1080]) + 255
    img[:, :, 1] = np.ones([1920, 1080]) + 254
    img[:, :, 2] = np.ones([1920, 1080]) * 255
    cv.imshow("iamge", img)
    img2 = np.zeros([1920, 1080, 3], np.uint8) + 255
    cv.imshow("iamge2", img2)
    cv.waitKey(0)


create_image()