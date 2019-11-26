# _*_ coding:utf-8 _*_
from bs4 import BeautifulSoup

html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>

<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>

<p class="story">...</p>
"""

soup=BeautifulSoup(html_doc,'html.parser')
#格式化
# print(soup.prettify())

# print(soup.title)
# print(soup.html)
# print(soup.p)

# 标签名
# print(soup.title.name)

# 标签内容
# print(soup.title.string)

# 父级标签名称
# print(soup.title.parent)
# print(soup.title.parent.name)
#print(soup.p['class'])
#print(soup.p['class'][0])

# 从文档中找到所有<a>标签的链接:
# print(soup.find_all('a'))
# for link in soup.find_all('a'):
#     print(link.get('href'))
#     print(link.get('id'))
#     print(link.get('class')[0])
# 查找id=link3的标签
# print(soup.find(id='link3'))

# 获取所有文本
# print(soup.get_text())



# 对象的种类
tag=soup.p
tag.name='dada'
print(tag.atter)


