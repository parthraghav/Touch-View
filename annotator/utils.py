import cv2


def showImage(imgData):
    cv2.imshow('image', imgData)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


def showImageFromFile(imgPath):
    imgData = cv2.imread(imgPath)
    showImage(imgData)


def getImage(imgPath):
    return cv2.imread(imgPath)


def getTestImage():
    return getImage('./tests/2.jpg')
