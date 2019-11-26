# coding:utf8
import re
import requests
import random
from zlib import crc32
from base64 import b64decode


def get_video_url_api(video_id):
    """获取视频地址所在包的url"""
    r = str(random.random())[2:]
    url_part = "/video/urls/v/1/toutiao/mp4/{}?r={}".format(video_id, r)
    s = crc32(url_part.encode())
    url = "https://ib.365yg.com{}&s={}".format(url_part, s)
    return url


def get_video_url(url):
    """获取视频地址"""
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36",
    }
    resp = requests.get(url, headers=headers)
    j_resp = resp.json()
    video_url = j_resp['data']['video_list']['video_1']['main_url']
    video_url = b64decode(video_url.encode()).decode()
    return video_url


def get_video_id(url):
    """获取视频id"""
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36",
    }
    resp = requests.get(url, headers=headers)
    # 获取video_id
    search=re.search("videoId: '([^\']+)'", resp.text)
    return search.group(1)


def main():
    url = "https://www.ixigua.com/a6562763969642103303/"
    url = "https://www.ixigua.com/a6562393171530088967/#mid=5577050366"
    #
    # video_id = get_video_id(url)
    video_id = 'i6759818363746124302'
    #
    video_url_api = get_video_url_api(video_id)
    #
    video_url = get_video_url(video_url_api)
    print(video_url)
    return


if __name__ == '__main__':
    main()