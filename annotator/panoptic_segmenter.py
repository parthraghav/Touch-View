# python3 -m annotator.panoptic_segmenter

from detectron2.data import MetadataCatalog
from detectron2.config import get_cfg
from detectron2.engine import DefaultPredictor
from detectron2 import model_zoo


class PanopticSegmenter(object):
    def __init__(self, *args):
        super(PanopticSegmenter, self).__init__(*args)
        self.configure()
        self.predictor = DefaultPredictor(self.cfg)

    def configure(self):
        self.cfg = get_cfg()
        self.cfg.MODEL.DEVICE = 'cpu'
        self.cfg.merge_from_file(model_zoo.get_config_file(
            "COCO-PanopticSegmentation/panoptic_fpn_R_101_3x.yaml"))
        self.cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url(
            "COCO-PanopticSegmentation/panoptic_fpn_R_101_3x.yaml")
        self.meta_data = MetadataCatalog.get(self.cfg.DATASETS.TRAIN[0])

    def predict_segments(self, img):
        return self.predictor(img)["panoptic_seg"]
