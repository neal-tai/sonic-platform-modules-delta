#!/bin/bash

# Usage:
# Set QSFP manually by writing 1/0 to QSFP reset/lpmode pin

QSFP_SELECTPORT="/sys/bus/i2c/devices/5-0050/sfp_select_port"
SWPLD_ADDRPATH="/sys/bus/i2c/devices/6-0031/addr"
SWPLD_DATAPATH="/sys/bus/i2c/devices/6-0031/data"
BIT="0xff"

set_reset_addr(){
  case ${1} in
    "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8")
      echo 0x3c > $SWPLD_ADDRPATH
      ;;
    "9"|"10"|"11"|"12"|"13"|"14"|"15"|"16")
      echo 0x3d > $SWPLD_ADDRPATH
      ;;
    "17"|"18"|"19"|"20"|"21"|"22"|"23"|"24")
      echo 0x3e > $SWPLD_ADDRPATH
      ;;
    "25"|"26"|"27"|"28"|"29"|"30"|"31"|"32")
      echo 0x3f > $SWPLD_ADDRPATH
      ;;
    *);;
  esac
}

set_lpmode_addr(){
  case ${1} in
    "1"|"2"|"3"|"4"|"5"|"6"|"7"|"8")
      echo 0x34 > $SWPLD_ADDRPATH
      ;;
    "9"|"10"|"11"|"12"|"13"|"14"|"15"|"16")
      echo 0x35 > $SWPLD_ADDRPATH
      ;;
    "17"|"18"|"19"|"20"|"21"|"22"|"23"|"24")
      echo 0x36 > $SWPLD_ADDRPATH
      ;;
    "25"|"26"|"27"|"28"|"29"|"30"|"31"|"32")
      echo 0x37 > $SWPLD_ADDRPATH
      ;;
    *)
    ;;
  esac
}

set_data(){
  if [ "${1}" -gt "0" ] && [ "${1}" -lt "9" ]; then
    val=$(( $BIT & (~(1 << (8 - (${1} % 8))))))
    printf -v HEX "%x" "${val}"
    echo "${HEX}" > $SWPLD_DATAPATH
  elif [ "${1}" -gt "8" ] && [ "${1}" -lt "17" ]; then
    val=$(( $BIT & (~(1 << (8 - (${1} % 8))))))
    printf -v HEX "%x" "${val}"
    echo "${HEX}" > $SWPLD_DATAPATH
  elif [ "${1}" -gt "16" ] && [ "${1}" -lt "25" ]; then
    val=$(( $BIT & (~(1 << (8 - (${1} % 8))))))
    printf -v HEX "%x" "${val}"
    echo "${HEX}" > $SWPLD_DATAPATH
  elif [ "${1}" -gt "24" ] && [ "${1}" -lt "33" ]; then
    val=$(( $BIT & (~(1 << (8 - (${1} % 8))))))
    printf -v HEX "%x" "${val}"
    echo "${HEX}" > $SWPLD_DATAPATH
  fi
}

if [ ${1} = "QSFP" ]; then
  case ${2} in
    "set")
      case ${3} in
        "port")
          case ${5} in
            "reset")
              if [ ${4} = "all" ]; then
                echo "Set reset all port "
                for i in $(seq 1 32)
                  do
                    set_reset_addr $i
                    sleep 1
                    set_data $i
                  done     
              else
                echo "Set reset in port ${4}"
                set_reset_addr ${4}
                sleep 1
                set_data ${4}
              fi
              ;;
            "lpmode")
              if [ ${4} = "all" ]; then
                echo "Set lpmode all port "
                for i in $(seq 1 32)
                  do
                    set_lpmode_addr $i
                    sleep 1
                    set_data $i
                  done 
              else                  
                echo "Set lpmode in port ${4}"
                set_lpmode_addr ${4}
                sleep 1
                set_data ${4}
              fi
              ;;
            *)
              echo "Usage ${0} QSFP set port {1-32}/all reset/lpmode"
              ;;
          esac
          ;;
        "")
          echo "Usage ${0} QSFP set port {1-32}/all"
          ;;
        *)
          echo "Usage ${0} QSFP set port {1-32}/all reset/lpmode"
          ;;
      esac
      ;;
    "get")
      echo "Usage ${0} QSFP set port {1-32}/all reset/lpmode"
      ;;
    "")
      echo "Enter parameters, ex> {${0} QSFP set/get}"
      ;;
    *)
      echo "Usage ${0} QSFP set port {1-32}/all reset/lpmode"
      ;;
  esac
else
  echo "Usage ${0} QSFP set port {1-32}/all reset/lpmode"
fi
