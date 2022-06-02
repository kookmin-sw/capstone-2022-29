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
#             f.write(word+',,,,SL,*,T,'+word+',*,*,*,*,*\n')


for word in ['알감자', '스테이블코인', '아르헨티나', '국가', '배달비', '홈트', '을왕리', '4강', '8강', '16강', '32강', '64강', '128강', '서울시장', '성남시장', '맞장', '우크라이나', '키이우', '아르헨티나', '아르헨', ]:
    if is_korean(word):
        if has_jongseong(word):
            print(word)
            f.write(word+',,,,NNP,*,T,'+word+',*,*,*,*,*\n')
        else:
            f.write(word+',,,,NNP,*,F,'+word+',*,*,*,*,*\n')
    else:
        f.write(word+',,,,SL,*,T,'+word+',*,*,*,*,*\n')
f.close()

