#!/bin/sh
WEATHERNOW=`curl -s -H "Cookie:f_city=%E5%B9%BF%E4%B8%9C%7C101280101%7C" -H "Host:d1.weather.com.cn" -H "Referer:http://www.weather.com.cn/weather1d/101280101.shtml" http://d1.weather.com.cn/sk_2d/101280101.html | cut -d"=" -f2 `


while [ ! -n "$WEATHERNOW" ]
do 
  WEATHERNOW=`curl -s -H "Cookie:f_city=%E5%B9%BF%E4%B8%9C%7C101280101%7C" -H "Host:d1.weather.com.cn" -H "Referer:http://www.weather.com.cn/weather1d/101280101.shtml" http://d1.weather.com.cn/sk_2d/101280101.html | cut -d"=" -f2 `
  sleep 2;
done

echo "$WEATHERNOW" | jq ".temp" | cut -d"\"" -f2 > /tmp/conkyweather
echo "$WEATHERNOW" | jq ".weathere" | cut -d"\"" -f2 >> /tmp/conkyweather

WEATHER_INFO="`curl -s http://en.weather.com.cn/weather/101280101.shtml?index=2 | sed -n '/Weather</,/table>/p'`"
while [ ! -n "$WEATHER_INFO" ]
do
  WEATHER_INFO="`curl -s http://en.weather.com.cn/weather/101280101.shtml?index=2 | sed -n '/Weather</,/table>/p'`";
  sleep 2;
done

echo "$WEATHER_INFO" |grep -m4 ℃ | sed -r "1,4s/.*>([0-9]*℃)<.*/\1/" >> /tmp/conkyweather
WEATHER_PICS=`echo "$WEATHER_INFO" |grep -m2 d[0-9]*.png | sed -r 's/.*src="(.*.png)".*/\1/'`

curl -s `echo "$WEATHER_PICS" | sed -n '1p'` > /tmp/conkyweather_today.png
curl -s `echo "$WEATHER_PICS" | sed -n '2p'` > /tmp/conkyweather_tomorrow.png

