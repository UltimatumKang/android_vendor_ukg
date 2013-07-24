cd ../../..
echo What is the brand of the device?
read brand
echo What is the device\'s codename?
read device
echo 'What wireless technology does the device use? (GSM or CDMA) (Use lowercase)'
read radio
echo 'What is the DPI of the device?'
read dpi
echo Ripping things from cm.mk...
cd device/$brand/$device
release_name=$(cat cm.mk | grep PRODUCT_RELEASE_NAME
PRODUCT_MODEL=$(cat cm.mk | grep PRODUCT_MODEL)
etc=$(cat cm.mk | grep PRODUCT_BUILD_PROP_OVERRIDES)
echo Generating ukg.mk
touch ukg.mk
echo '#
# Copyright (C) 2012 The CyanogenMod Project
# Copyright (C) 2013 Ultumatumdev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# name' > ukg.mk
echo 'PRODUCT_RELEASE_NAME := '$release_name >> ukg.mk
echo '
# device' >> ukg.mk
echo '$(call inherit-product-if-exists, device/'$brand'/'$device'/full_'$device'.mk)' >> ukg.mk
if [ $radio == "gsm" ]
then
echo '
# gsm' >> ukg.mk
echo '$(call inherit-product, vendor/ukg/config/common_gsm.mk)' >> ukg.mk
fi
if [ $radio == "cdma" ]
then
echo '
# cdma' >> ukg.mk
echo '$(call inherit-product, vendor/ukg/config/common_cdma.mk)' >> ukg.mk
fi
echo '
# languages
PRODUCT_LOCALES := en_US de_DE zh_CN zh_TW cs_CZ nl_BE nl_NL en_AU en_GB en_CA en_NZ en_SG fr_BE fr_CA fr_FR fr_CH de_AT de_LI de_CH it_IT it_CH ja_JP ko_KR pl_PL ru_RU es_ES ar_EG ar_IL bg_BG ca_ES hr_HR da_DK en_IN en_IE en_ZA fi_FI el_GR iw_IL hi_IN hu_HU in_ID lv_LV lt_LT nb_NO pt_BR pt_PT ro_RO sr_RS sk_SK sl_SI es_US sv_SE tl_PH th_TH tr_TR uk_UA vi_VN

# phone
$(call inherit-product, vendor/ukg/config/common_phone.mk)

# products' >> ukg.mk
echo 'PRODUCT_DEVICE := '$device >> ukg.mk
echo 'PRODUCT_BRAND := '$brand >> ukg.mk
echo 'PRODUCT_NAME := ukg_'$device >> ukg.mk
echo $PRODUCT_MODEL >> ukg.mk
echo 'PRODUCT_MANUFACTURER := '$brand >> ukg.mk
echo 'PRODUCT_PROPERTY_OVERRIDES += ro.buildzipid=ukg.'$device'.$(shell date +%m%d%y).$(shell date +%H%M%S)' >> ukg.mk
echo '
# overrides' >> ukg.mk
echo $etc >> ukg.mk
echo '
# hybrid
PRODUCT_COPY_FILES +=  \' >> ukg.mk
echo '    vendor/ukg/prebuilt/hybrid_'$dpi'.conf:system/etc/beerbong/properties.conf \
    vendor/ukg/prebuilt/bootanimation/bootanimation.zip:system/media/bootanimation.zip' >> ukg.mk
echo Removing uneeded things...
rm -rf cm* *sh AndroidProducts.mk
echo 'Does the device have Hardware Buttons? (true/false)'
read hardkeys
echo 'Does the device support Fast Charge? (true/false) (Say yes if you are using a custom kernel)'
read fastcharge
echo 'Does the device have color tuning? (true/false) (Usually no. If you are using a custom kernel that supports it, say yes.)'
read colortune
echo 'Does the device have LED charging feature? (true/false) (Usually yes if you have Notification LED)'
read chargingled
echo 'Does the device have a common repo? (Enter the repo name if true, otherwise type false.)'
read commonrepo
if [ $commonrepo != "false" ]
then
cd ../$commonrepo
fi
cd overlay/packages/apps
mkdir uTool && cd uTool
mkdir res && cd res
mkdir values && cd values
echo '<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Whether device has hardware buttons -->
    <bool name="has_hardware_buttons">'$hardkeys'</bool>

    <!-- Whether can use fast charge -->
    <bool name="has_fast_charge">'$fastcharge'</bool>

    <!-- Whether can use color tuning -->
    <bool name="has_color_tuning">'$colortune'</bool>

    <!-- Whether device has led charging feature -->
    <bool name="has_led_charging_feature">'$chargingled'</bool>
</resources>' > config.xml
cd ../../..
echo Done
