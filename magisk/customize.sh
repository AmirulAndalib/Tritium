# Copyright 2023 - present Tritium Developers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

[ -f "$MODPATH/skt-utils.sh" ] && . "$MODPATH/skt-utils.sh" || abort '! File "skt-utils.sh" does not exist!'

skt_mod_install # Don't write code before this line!

SKIPUNZIP=0
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

set_perm_recursive $MODPATH 0 0 0755 0644

rm -f /data/powercfg.json /data/powercfg.sh

cp -f "$MODPATH/powercfg/powercfg.json" /data/
cp -f "$MODPATH/powercfg/powercfg.sh" /data/

ui_print "- Tritium Scheduler Module"
ui_print "- Installing..."

ui_print "- 当前版本为: 正式版"
ui_print "- 构建时间: $(stat -c '%y' "$MODPATH/module.prop" | cut -d: -f1,2)"
ui_print "- Soc平台: $(getprop ro.product.brand)"
ui_print "- CPU型号: $(getprop ro.board.platform)"
ui_print "- 手机代号: $(getprop ro.product.board)"
ui_print "- 安卓版本: $(getprop ro.build.version.release)"
ui_print "- SDK: $(getprop ro.build.version.sdk)"
ui_print "- 内核版本: $(uname -r)"

get_pineapple_name() {
    cpu_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    if [ "$cpu_max_freq" -gt 3200000 ]; then
        echo "sdm8gen3"
    else
        echo "sdm7+gen3"
    fi
}

get_taro_name() {
    cpu7_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    gpu_max_freq=$(cat /sys/class/kgsl/kgsl-3d0/max_clock_mhz)
    if [ "$cpu7_max_freq" -gt 3100000 ]; then
        echo "sdm8+gen1"
    elif [ "$cpu7_max_freq" -gt 2950000 ]; then
        if [ "$gpu_max_freq" -gt 850 ]; then
            echo "sdm8+gen1"
        else
            echo "sdm8gen1"
        fi
    elif [ "$cpu7_max_freq" -gt 2900000 ]; then
        echo "sdm7+gen2"
    else
        echo "sdm7gen1"
    fi
}

get_lahaina_name() {
    cpu7_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    cpu4_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy4/cpuinfo_max_freq)
    if [ "$cpu7_max_freq" -gt 2800000 ]; then
        echo "sdm888"
    elif [ "$cpu4_max_freq" -gt 2300000 ]; then
        echo "sdm778"
    else
        echo "sdm780"
    fi
}

get_lito_name() {
    cpu_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    if [ "$cpu_max_freq" -gt 2300000 ]; then
        echo "sdm765"
    else
        echo "sdm750"
    fi
}

get_sm6150_name() {
    cpu_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    if [ "$cpu_max_freq" -gt 2200000 ]; then
        echo "sdm730"
    else
        echo "sdm675"
    fi
}

get_mt6895_name() {
    cpu_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    if [ "$cpu_max_freq" -gt 3000000 ]; then
        echo "dimensity8200"
    else
        echo "dimensity8100"
    fi
}

get_bengal_name() {
    cpu_max_freq=$(cat /sys/devices/system/cpu/cpufreq/policy7/cpuinfo_max_freq)
    if [ "$cpu_max_freq" -gt 2300000 ]; then
        echo "sdm680"
    else
        echo "sdm665"
    fi
}

get_config_name() {
    case "$1" in
    crow*)
        echo "sdm7gen3"
        ;;
    garnet*)
        echo "sdm6gen1"
        ;;
    parrot*)
        echo "sdm6gen1"
        ;;
    pineapple*)
        get_pineapple_name
        ;;
    sunstone*)
        echo "sdm4gen1"
        ;;
    sky*)
        echo "sdm4gen2"
        ;;
    kalama*)
        echo "sdm8gen2"
        ;;
    sun*)
        echo "sdm8elite"
        ;;
    taro*)
        get_taro_name
        ;;
    lahaina*)
        get_lahaina_name
        ;;
    shima*)
        get_lahaina_name
        ;;
    yupik*)
        get_lahaina_name
        ;;
    kona*)
        echo "sdm865"
        ;;
    msmnile*)
        echo "sdm855"
        ;;
    sdm845*)
        echo "sdm845"
        ;;
    lito*)
        get_lito_name
        ;;
    sm7150*)
        echo "sdm730"
        ;;
    sm6150*)
        get_sm6150_name
        ;;
    sdm670*)
        echo "sdm710"
        ;;
    sdm710*)
        echo "sdm710"
        ;;
    sdm439*)
        echo "sdm439"
        ;;
    sdm450*)
        echo "sdm625"
        ;;
    sdm4350*)
        echo "sdm730"
        ;;
    msm8953*)
        echo "sdm625"
        ;;
    sdm660*)
        echo "sdm660"
        ;;
    sdm636*)
        echo "sdm660"
        ;;
    sdm632*)
        echo "sdm660"
        ;;
    sdm630*)
        echo "sdm630"
        ;;
    trinket*)
        echo "sdm665"
        ;;
    bengal*)
        get_bengal_name
        ;;
    holi*)
        echo "sdm4gen1"
        ;;
    msm8998*)
        echo "sdm835"
        ;;
    msm8996*)
        echo "sdm820"
        ;;
    mt6771*)
        echo "helio_p60"
        ;;
    mt6779*)
        echo "helio_g80"
        ;;
    mt6762*)
        echo "helio_p35"
        ;;
    mt6765*)
        echo "helio_p35"
        ;;
    mt6768*)
        echo "helio_g80"
        ;;
    mt6785*)
        echo "helio_g90"
        ;;
    mt6789*)
        echo "helio_g99"
        ;;
    mt6799*)
        echo "helio_x30"
        ;;
    mt6833*)
        echo "dimensity700"
        ;;
    mt6835*)
        echo "helio_g99"
        ;;
    mt6853*)
        echo "dimensity700"
        ;;
    mt6873*)
        echo "dimensity820"
        ;;
    mt6875*)
        echo "dimensity820"
        ;;
    mt6877*)
        echo "dimensity900"
        ;;
    mt6878*)
        echo "dimensity7300"
        ;;
    mt6885*)
        echo "dimensity1000"
        ;;
    mt6886*)
        echo "dimensity7200"
        ;;
    mt6889*)
        echo "dimensity1000"
        ;;
    mt6891*)
        echo "dimensity1100"
        ;;
    mt6893*)
        echo "dimensity1100"
        ;;
    mt6895*)
        get_mt6895_name
        ;;
    mt6897*)
        echo "dimensity8300"
        ;;
    mt6899*)
        echo "dimensity8400"
        ;;
    mt6983*)
        echo "dimensity9000"
        ;;
    mt6985*)
        echo "dimensity9200"
        ;;
    mt6989*)
        echo "dimensity9300"
        ;;
    mt6991*)
        echo "dimensity9400"
        ;;
    kirin970*)
        echo "kirin970"
        ;;
    hi3670*)
        echo "kirin970"
        ;;
    hi3660*)
        echo "kirin960"
        ;;
    hi3650*)
        echo "kirin950"
        ;;
    kirin710*)
        echo "kirin710"
        ;;
    hi6250*)
        echo "kirin650"
        ;;
    sp9863a*)
        echo "sc9863a"
        ;;
    ums512*)
        echo "unisoc_t618"
        ;;
    ud710*)
        echo "unisoc_t740"
        ;;
    ums9620*)
        echo "unisoc_t770"
        ;;
    ums9230*)
        echo "unisoc_t618"
        ;;
    *)
        echo "unsupport"
        ;;
    esac
}

ui_print "- Extracting module files."
if [ -d "$MODPATH" ]; then
    rm -rf "$MODPATH"
fi
unzip -o "$ZIPFILE" -x "META-INF/*" -d "$MODPATH" >/dev/null 2>&1
chmod -R 0777 "$MODPATH"

platform_name=$(getprop "ro.board.platform")
config_name=$(get_config_name "$platform_name")
if [ -f "${MODPATH}/configs/${config_name}.json" ]; then
    cp -f "${MODPATH}/configs/${config_name}.json" "${MODPATH}/config.json"
    rm -rf "${MODPATH}/configs/"

    ui_print "- ${platform_name} 您的芯片已适配😋."
    ui_print "- Installation finished."
else
    ui_print "- ${platform_name} 您的芯片未适配😑"
    abort "- Abort!"
fi


skt_mod_install_finish # Don't write code after this line!

