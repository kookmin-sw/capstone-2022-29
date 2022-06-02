import pandas as pd

def has_jongseong(word):
    return (ord(word[-1]) - 44032) % 28 != 0

def is_korean(word):
    code = ord(word[-1])
    if 44032 <= code <= 55203:
        return True
    return False

file = "./queries.csv"
user_dic_file = "./user_dic.csv"


# queries_df = pd.read_csv(file)
f = open(user_dic_file, 'a')

# for q in queries_df['query']:
#     q = q.split()
#     for word in q:
#         if is_korean(word):
#             if has_jongseong(word):
#                 print(word)
#                 f.write(word+',,,,NNP,*,T,'+word+',*,*,*,*,*\n')
#             else:
#                 f.write(word+',,,,NNP,*,F,'+word+',*,*,*,*,*\n')
#         else:
#             f.write(word+',,,,SLㅑ,ㅑi*,T,'+word+',*,*,*,*,*\n')


for word in ['유벤투스', 'AC 밀란', '뮌헨', '파리 생 제르맹', '리버풀', '아스날', '첼시', '맨체스터 유나이티드', '레알 마드리드', 'FC 바르셀로나', '토트넘', '벤투호', '홍명보호', 'fc 서울', 'fc 전북']:
    if is_korean(word):
        if has_jongseong(word):
            print(word)
            f.write(word+',,,,NNP,*,T,'+word+',*,*,*,*,*\n')
        else:
            f.write(word+',,,,NNP,*,F,'+word+',*,*,*,*,*\n')
    else:
        f.write(word+',,,,SL,*,T,'+word+',*,*,*,*,*\n')
f.close()

