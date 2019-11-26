
# coding=utf-8  
import re  
import urllib.request  
url = "http://www.baidu.com/"  
content = urllib.request.urlopen(url).read().decode('utf-8')
 

#获取超链接<a>和</a>之间内容
res = r"<a.*?href=.*?<\/a>" 
texts = re.findall(res,content,re.M|re.S)  
for target_list in texts:
    print (target_list)
# for t in texts:
#     print(t)