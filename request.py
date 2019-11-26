# _*_ coding:utf-8 -*_

import requests


###########################3 get请求

r=requests.get('https://www.douban.com/search',params={'q':'pyrhon'})
# print(r.status_code)
# print(r.text)
# print(r.url)
# print(r.encoding) #自动检测编码
# print(r.content) #用content属性获得bytes对象：

# print(r.headers['Content-Encoding'])  #获取指定响应头

# print(r.cookies)


# json=requests.get('https://pvp.qq.com/web201605/js/herolist.json',headers={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36'})
# print(json.json()) #请求json返回json

############################# post请求
# data={'user':'100','passwd':'100'}
# r=requests.post('http://httpbin.org/basic-auth/100/100',json=data)
# print(r.status_code)





# response =requests.get('https://www.baidu.com')
# print(type(response)) #类型
# print(response.status_code) #状态码
# print(type(response.text))
# print(response.text)
# print(response.cookies['BDORZ']) #获取cookie

# 各种请求方式
# print(requests.post('http://httpbin.org/post'))
# print(requests.put('http://httpbin.org/put'))
# print(requests.delete('http://httpbin.org/delete'))
# print(requests.head('http://httpbin.org/get'))
# print(requests.options('http://httpbin.org/get'))

headers={
    'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36'
}
# 基本写法

# response=requests.get('http://httpbin.org/get')
# print(response.text)


# 带参数的GET请求1
# response=requests.get('http://httpbin.org/get?name=wangwei&age=22')
# print(type(response.text))
# print(response.json)
# print(response.text)



# 带参数的GET请求2
# data={
#     'name':'wangwei',
#     'age':22
# }
# response=requests.get('http://httpbin.org/get',params=data)
# print(response.text)
# print(type(response.json()))
# print(response.json()['args']) #解析json取传递的参数


# 解析json1
# data={
#     'name':'wangwei',
#     'age':22
# }
# response=requests.get('http://httpbin.org/get',params=data)
# print(response.json())
# # 解析json2
# import json
# print(json.loads(response.text))


# 获取二进制数据，下载图片，下载视频
# response=requests.get('https://www.baidu.com/img/bd_logo1.png')
# print(type(response.text),type(response.content))
# # print(response.text)
# print(response.content) #获取二进制内容
# with open('./baidulogo.png','wb') as bd_logo:
#     bd_logo.write(response.content)
#     bd_logo.close()


# 视频练习-失败
# vodeo=requests.get('http://vodkgeyttp8.vod.126.net/cloudmusic/9e83/core/34b5/a02d8b8ef9389b887f0ce7c7f3892691.mp4?wsSecret=6c6b70a7d67777556bad693ab7ccd2f4&wsTime=1573972148')
# # print(vodeo.content)
# print(vodeo.status_code)
# print('loding...')
# with open('./你的答案-mv.mp4','wb') as target:
#     target.write(vodeo.content)
#     target.close()
#     print('done')


# 添加headers
# 以知乎为例-不添加headers会返回400
# response=requests.get('https://www.zhihu.com/explore')
# print(response.text)
# print(response.status_code)


# response=requests.get('https://www.zhihu.com/explore',headers=headers)
# print(response.status_code) #添加headers会正常返回
# print(response.text)



# 总结：各种请求方式后常用的get,post，
# 2相关函数 text，status_code,json,
# 3参数传递，直接链接传递参数和使用params传递是结果是一致的，
# 4二进制流的下载方式 open方法
# 5添加headers 请求参数




# 2.基本post请求方法
# data={'name':'wangwei','age':22}
# # 添加headers
# response=requests.post('http://httpbin.org/post',data=data,headers=headers)
# print(response.status_code)
# print(response.text)




# 3.responses属性
# response=requests.get('http://www.jianshu.com',headers=headers)
# print(type(response.status_code),response.status_code) #返回状态码
# print(type(response.headers),response.headers) #返回headers
# print(type(response.cookies),response.cookies) #返回cookies
# print(type(response.url),response.url) #返回url
# print(type(response.history),response.history) #返回历史记录
# print(type(response.content),response.content) #返回请求的内容，与text最大的区别是返回的是二进制的内容，text返回的是默认编码（Unicode）的内容，可能存在乱码且需要转码
# print(type(response.encoding),response.encoding) #返回编码格式

# response.encoding='ISO-8859-1'
# print(response.text)   #会乱码

# 4.状态码判断
# response=requests.get('http://www.jianshu.com',headers=headers)

# if response.status_code==requests.codes['ok']:
#     print('requests successfuly')
# else:
#     print('requests error')







# 5 高级用法
# # 文件上传练习-上传上边下载的百度logo,使用post方式的files方法
# img={'file':open('baidulogo.png','rb')} #读取文件，保存成files参数 注意是：号
# response=requests.post('http://httpbin.org/post',files=img,headers=headers)
# print(response.text)



# # 获取cookies-以百度为例
# response=requests.get('https://www.baidu.com',headers=headers)
# for cookies_key,cookles_values in response.cookies.items(): #注意使用cookies.item()方法，否则报错 获取key,value值
#     print(cookies_key+'='+cookles_values)



# 会话维持-模拟登陆
# 错误方法
# requests.get('http://httpbin.org/cookies/set?freeform=123456')
# response=requests.get('http://httpbin.org/cookies')
# print(response.text)


# session=requests.Session() #维持会话信息，创建session对象，使用session对象来请求url
# session.get('http://httpbin.org/cookies/set?freeform=123456')
# response=session.get('http://httpbin.org/cookies')
# print(response.text)




# # 证书验证 verify 参数
# from requests.packages import urllib3
# urllib3.disable_warnings() #使用此方法消除证书提示
# response=requests.get('https://superssr.xyz/',headers=headers,verify=False) #关闭证书验证会有验证提示，关闭提示需要导入urllib3
# print(response.status_code)


# # 代理设置 代理来自http://free-proxy.cz/zh/proxylist/country/CN/http/ping/all
# proxies={
#     'http':'150.109.55.190:83',
#     'https':'150.109.60.185:8888'
# }
# response=requests.get('https://www.taobao.com')
# print(response.status_code)


# # 超时设置 timeout参数设置超时时间
# from requests.exceptions import ReadTimeout #引入ReadTimeout库
# try: #超时异常捕获
#     response=requests.get('http://www.httpbin.org/get',timeout=0.5) #设置超时时间
#     print(response.status_code)
# except ReadTimeout:
#     print('error') #在规定时间内没返回结果则输出error信息


# # 认证设置1 使用 HTTPBasicAuth库传递默认值 HTTPBasicAuth('1','1')
# from requests.auth import HTTPBasicAuth
# response=requests.get('http://httpbin.org/basic-auth/11/11',auth=HTTPBasicAuth('11','11'))
# # 认证设置2 使用auth参数来传递
# response2=requests.get('http://httpbin.org/basic-auth/22/22',auth=("22","22"))

# print('HTTPBasicAuth:%s' % response.status_code)
# print('auth:%s' % response2.status_code)


# # 异常处理归纳
# # # 1,HTTPError
# # # 2,ReadTimeout 请求url超时，异常处理
# # # 3,RequestException
# # # 4,ConnectionError 网络请求相关，没网等等
# from requests.exceptions import HTTPError,ReadTimeout,RequestException,ConnectionError
# try:
#     response=requests.get('http://httpbin.org/get',timeout=0.5)
#     print(response.status_code)
# except HTTPError:
#     print('HTTP Error')
# except ReadTimeout:
#     print('Read Timeout')
# except RequestException:
#     print('Request Excepton')




# # re
import re
print(re.search('www','www.baidu.com'))
# get_video_id('https://www.ixigua.com/i6759818363746124302/')
# def get_video_id(url):
#     """获取视频id"""
#     resp = requests.get(url, headers=headers)
#     # 获取video_id
#     search=re.search("videoId: '([^\']+)'", resp.text)
#     return search.group(1)