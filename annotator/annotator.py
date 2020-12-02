# python3 -m annotator.annotator

import cv2
from annotator.panoptic_segmenter import PanopticSegmenter
from annotator.exif import MetaDataManager
from PIL import Image
import torch
import cv2
import sys


class Annotator(object):

    def __init__(self, *args):
        super(Annotator, self).__init__(*args)
        self.panopticSegmenter = PanopticSegmenter()

    def getAnnotationData(self, imgPath):
        return self._makeAnnotation(imgPath)

    def annotate(self, imgPath):
        referenceImage = MetaDataManager.read(imgPath)
        isImageAnnotated = referenceImage.doesKeyExist(
            'segmentData') and referenceImage.doesKeyExist('labelData')
        if not isImageAnnotated:
            annotation = self._makeAnnotation(imgPath)
            referenceImage.put(annotation)
            return True
        return False

    def _makeAnnotation(self, imgPath):
        targetImage = cv2.imread(imgPath)
        targetImage = cv2.cvtColor(targetImage, cv2.COLOR_BGR2RGB)
        segments = self.panopticSegmenter.predict_segments(targetImage)
        segmentMatrix = segments[0]
        segmentLabels = segments[1]
        self.segmentMetaData = self.panopticSegmenter.meta_data
        self.labelData = self.getCategoryLabelNames(segmentLabels)
        self.segmentData = self.exportToCSV(segmentMatrix)
        return {
            'segmentData': self.segmentData,
            'labelData': self.labelData,
            'dimensions': {
                'height': segmentMatrix.size()[0],
                'width': segmentMatrix.size()[1],
            }
        }

    def getCategoryLabelNames(self, segmentLabels):
        res = []
        for rawSegmentLabel in segmentLabels:
            segmentId = rawSegmentLabel['category_id']
            if rawSegmentLabel['isthing']:
                label = self.segmentMetaData.thing_classes[segmentId]
            else:
                label = self.segmentMetaData.stuff_classes[segmentId]
            res.append({'category_id': segmentId,
                        'category_label': label})
        return res

    def exportToCSV(self, mat: torch.tensor):
        return ','.join(','.join('%d' % x for x in y) for y in mat)

    def isAnnotated(self):
        raise NotImplementedError()
