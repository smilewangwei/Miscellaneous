#!/usr/bin/env python
# -*- coding: utf-8 -*-
# [url=home.php?mod=space&uid=238618]@Time[/url]    : 2019/12/1 12:41
# [url=home.php?mod=space&uid=686208]@AuThor[/url]  : jenny
# [url=home.php?mod=space&uid=267492]@file[/url]    : down_dy.py
# @Software: PyCharm
import requests
import os
import sys
import io
import json
import cv2
import re
sys.stdout = io.TextIOWrapper( sys.stdout.buffer, encoding='utf-8')
def getmidstring(html, start_str, end):
    start = html.find(start_str)
    if start >= 0:
        start += len(start_str)
        end = html.find(end, start)
        if end >= 0:
            return html[start:end].strip()
class video():
    def urlencode(self,url):
        session = requests.session()
        headers={
            "User-Agent":"Aweme/86018 CFNetwork/978.0.7 Darwin/18.7.0"
        }
        response = session.get(url,headers=headers,allow_redirects=False)
        videoid = getmidstring(response.headers["Location"],'share/video/','/?region')
        self.video_id = videoid
        headers={
            'User-Agent': 'Aweme 8.6.0 rv:86018 (iPhone; iOS 12.4.1; zh_CN) Cronet',
            'Content-Type':'application/x-www-form-urlencoded',
            'Cookie':'odin_tt=84d9ca70201e16dc571ddb0da31c51712edd39055d938f0bc5a2a56878a94c3c0fd53725db64aaa37470fafb633ff94c9941c30f7fba08ea2d1025647aba6685'
        }
        response = session.post('https://aweme-hl.snssdk.com//aweme/v1/aweme/detail/',headers=headers,data={'aweme_id':videoid})
        j = json.loads(response.text)
        self.video_url = j['aweme_detail']['video']['play_addr']['url_list'][0]
        self.mp3_url = j['aweme_detail']['music']['play_url']['url_list'][0]
        self.video_name = j['aweme_detail']['desc']
    def down_video(self):
        """
        下载视频
        :param video_url:
        :param naem:
        :return:
        """
        # 通过cv2中的类获取视频流操作对象cap
        cap = cv2.VideoCapture(self.video_url)
        # 调用cv2方法获取cap的视频帧（帧：每秒多少张图片）
        fps = cap.get(cv2.CAP_PROP_FPS)
        # 获取cap视频流的每帧大小
        size = (int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)),
                int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT)))
        # 定义编码格式mpge-4
        fourcc = cv2.VideoWriter_fourcc('M', 'P', '4', '2')
        # 定义视频文件输入对象
        outVideo = cv2.VideoWriter('%s.avi'%(self.video_id), fourcc, fps, size)
        tot = 1
        rval, frame = cap.read()
        # 循环使用cv2的read()方法读取视频帧
        while rval:
            rval, frame = cap.read()
            tot += 1
            # 使用VideoWriter类中的write(frame)方法，将图像帧写入视频文件
            outVideo.write(frame)
            cv2.waitKey(1)
        cap.release()
        outVideo.release()
        cv2.destroyAllWindows()
    def down_mp3(self):
        """
        #下载音频
        :param mp3_url:
        :param naem:
        :return:
        """
        response = requests.get(self.mp3_url)
        with open("%s.mp3"%(self.video_id), "wb") as f:
            f.write(response.content)
        f.close()
    def video_add_mp3(self):
        """
         视频添加音频
        :param video_file: 传入视频文件的路径
        :param mp3_file: 传入音频文件的路径
        :return:
        """
        video_file = ('%s.avi'%(self.video_id))
        mp3_file = ("%s.mp3"%(self.video_id))
 
        str = re.sub('[a-zA-Z0-9’!"#$%&\'()*+,-./:;<=>?@，。?★、…【】《》？“”‘’！[\\]^_`{|}~\s]+', "", self.video_name)
        outfile_name = "%s.avi"%str
        ffmpeg_cmd = "ffmpeg -i %s -i %s -c:v copy -c:a aac -strict experimental %s"%(video_file,mp3_file,outfile_name)
        os.system("%s"%ffmpeg_cmd)
        os.remove("%s"%video_file)
        os.remove("%s"%mp3_file)
if __name__ == '__main__':
    v = video()
    v.urlencode("https://v.douyin.com/CoHupf/")#分享的链接
    v.down_video()
    v.down_mp3()
    v.video_add_mp3()