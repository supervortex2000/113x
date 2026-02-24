#
# AML_NN_DETECT_MODEL
#
AML_NN_DETECT_MODEL_VERSION = 1.0
AML_NN_DETECT_MODEL_SITE = $(TOPDIR)/../vendor/amlogic/slt/npu_app/detect_library/nn_data
AML_NN_DETECT_MODEL_SITE_METHOD = local

define AML_NN_DETECT_MODEL_BUILD_CMDS
	cd $(@D);
endef

define AML_NN_DETECT_YOLO_V2
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) == "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v2/yolov2_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) == "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v2/yolov2_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v2/yolov2_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v2/yolov2_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v2/yolov2_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_DETECT_YOLO_V3
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v3/yolov3_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v3/yolov3_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v3/yolov3_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v3/yolov3_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yolo_v3/yolov3_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_DETECT_YOLOFACE
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yoloface/yolo_face_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yoloface/yolo_face_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yoloface/yolo_face_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yoloface/yolo_face_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/detect_yoloface/yolo_face_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_FACE_DETECTION
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_detection/aml_face_detection_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_detection/aml_face_detection_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_detection/aml_face_detection_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_detection/aml_face_detection_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_detection/aml_face_detection_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_FACE_RECOGNITION
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_recognition/aml_face_recognition_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_recognition/aml_face_recognition_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_recognition/aml_face_recognition_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_recognition/aml_face_recognition_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_face_recognition/aml_face_recognition_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_FACENET
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/facenet/facenet_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/facenet/facenet_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/facenet/facenet_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/facenet/facenet_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/facenet/facenet_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_PERSON_DETECTION
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "G12B" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_person_detection/aml_person_detection_88.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "SM1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_person_detection/aml_person_detection_99.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C1" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_person_detection/aml_person_detection_a1.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "TM2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_person_detection/aml_person_detection_b9.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
	if [ $(BR2_PACKAGE_AML_SOC_FAMILY_NAME) = "C2" ]; then \
		$(INSTALL) -D -m 0644 $(@D)/aml_person_detection/aml_person_detection_be.nb $(TARGET_DIR)/etc/nn_data/; \
	fi
endef

define AML_NN_DETECT_MODEL_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/etc/nn_data
	$(AML_NN_DETECT_YOLOFACE)
	$(AML_NN_FACE_DETECTION)
	$(AML_NN_FACE_RECOGNITION)
	$(AML_NN_FACENET)
	$(AML_NN_PERSON_DETECTION)
endef

define AML_NN_DETECT_MODEL_INSTALL_STAGING_CMDS
    $(AML_NN_DETECT_MODEL_INSTALL_STAGING_CMDS)
endef

$(eval $(generic-package))
