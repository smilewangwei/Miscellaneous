# _*_ coding:utf-8 _*_
from lxml import etree
import requests
from fake_useragent import UserAgent
from requests.exceptions import ReadTimeout
import re
import os

headers={
    'User-Agent':UserAgent().random
}
url='https://www.pearvideo.com/category_59'
response=requests.get(url,headers=headers,timeout=10)
res_xpath=etree.HTML(response.text) #第一步给内容转为xpath结构
# print(type(res_xpath),res_xpath)


# 提取文字方法、绝对路径1,相对路径2
title1=res_xpath.xpath('/html/head/title/text()')
title2=res_xpath.xpath('//title/text()')  #找到title输出文本
a=res_xpath.xpath('//a[@class="menu"]/text()')
a2=res_xpath.xpath('//ul[@id="categoryList"]/li[1]/div/a/div[@class="vervideo-title"]/text()')
a3=res_xpath.xpath('//ul[@id="categoryList"]/li/div/a/div[2]/text()')
herf2=['https://www.pearvideo.com/%s' % i for i in res_xpath.xpath('//ul[@id="categoryList"]/li/div/a/@href')]


video_response=requests.get('http://video.pearvideo.com/mp4/third/20191115/cont-1623196-10411777-172932-hd.mp4',headers=headers)
if os.path.exists('./vodeo'):
    os.makedirs('./vodeo')
with open('./vodeo/a.mp4','wb') as v:
    v.write(video_response.content)
    v.close()
    print('done')
    
# try:
#     for herf2_list in range(len(herf2)):
#         response2=requests.get(herf2[herf2_list],headers=headers,timeout=10)
#         if response2.status_code==requests.codes['ok']:
#             res2_xpath=etree.HTML(response2.text)
#             # print(res2_xpath.xpath('/html/head/title/text()'))
#             video=re.findall('srcUrl="(.*?)"',response2.text,re.S) #获取视频链接
#             print(video[0])
           
#             # try:
#             #     if os.path.exists('./vodeo'):
#             #         os.makedirs('./vodeo')
#             #     with open('./vodeo'+res2_xpath.xpath('/html/head/title/text()')+'.mp4','wb') as v:
#             #         v.write(video_response.content)
#             #         v.close()
#             #         print(res2_xpath.xpath('/html/head/title/text()')+'.mp4')
#             # except:
#             #     print('error')
#             # else:
#             #     print('done')
#         else:
#             print('requests error')
# except ReadTimeout:
#     print('time out error')
