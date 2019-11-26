# _*_ coding:utf-8 -*_
import urllib.request
import urllib.parse



heander={
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36'
    }


# 模拟百度请求
def baidu():
    url='http://www.baidu.com/s?wd='
    hello='hello 树先生'
    key_code=urllib.request.quote(hello) #包含中文 需要编码
    url_all=url+key_code
    request=urllib.request.Request(url_all,headers=heander)
    reponse=urllib.request.urlopen(request).read()
    print(reponse)

    fh=open("./baidu.html","wb") #写到文件中
    fh.write(reponse)
    fh.close()

# 模拟谷歌搜索
def google():
    url='https://www.google.com/search?&q='
    # 模拟请求
    hello='hello 树先生'
    key_code=urllib.request.quote(hello) #包含中文 需要编码
    url_all=url+key_code
    request=urllib.request.Request(url_all,headers=heander)
    reponse=urllib.request.urlopen(request).read()
    print(reponse)

    fh=open("./google.html","wb") #写到文件中
    fh.write(reponse)
    fh.close()


# 模拟post请求（https://www.iqianyue.com/mypost）
def getpost():
    url="https://www.iqianyue.com/mypost" #设置URL网址。
    data={"name":"fenxiang","pass":"123456","text":"dada"}
    postdata=urllib.parse.urlencode(data).encode('utf-8') #构建表单数据，并使用urllib.parse.urlencode对数据进行编码处理。
    request=urllib.request.Request(url,postdata) #构建Request对象，参数包括URL地址和要传递的数据。
    reponse=urllib.request.urlopen(request,timeout=10).read().decode('utf-8') #使用urllib.requesr.urlopen()打开对应的Request对象。完成信息的传递。

    fhandle=open("./getpost.html","wb") #将内容写入文件等。
    fhandle.write(reponse)
    fhandle.close()



# 认证登陆 使用账号密码进行登陆
def getname_pass():
    url="https://tieba.baidu.com/"
    user=''
    password=""
    pwdmgr=urllib.request.HTTPPasswordMgrWithDefaultRealm() #实例化账号密码管理对象
    pwdmgr.add_password(None,url,user,password) #add_password传入账号密码参数
    auth_handler=urllib.request.HTTPBasicAuthHandler(pwdmgr) #使用HTTPBasicAuthHandler方法的得到Handler对象
    opener=urllib.request.build_opener(auth_handler) #获取opener对象
    response=opener.open(url).read().decode('utf-8') #open()方法 发起URL请求
    print(response)


def pvpGame():
    url='https://pvp.qq.com/'

# 程序入口    
def main():
    # baidu()
    # google()
    # getpost()
    getname_pass()

if __name__ == "__main__":
    main()