import pandas as pd


def has_jongseong(word):
    return (ord(word[-1]) - 44032) % 28 != 0

def is_korean(word):
    code = ord(word[-1])
    if 44032 <= code <= 55203:
        return True
    return False

file = "C:\\Users\\rosy0\\OneDrive\\문서\\소융대 자료\\capstone-2022-29\\DM\\TopicModeling\\queries.csv"
user_dic_file = "C:\\Users\\rosy0\\OneDrive\\문서\\소융대 자료\\capstone-2022-29\\DM\\TopicModeling\\user_dic.csv"

queries_df = pd.read_csv(file)
f = open(user_dic_file, 'w')

for q in queries_df['query']:
    q = q.split()
    for word in q:
        if is_korean(word):
            if has_jongseong(word):
                print(word)
                f.write(word+',,,,NNP,*,T,'+word+',*,*,*,*,*\n')
            else:
                f.write(word+',,,,NNP,*,F,'+word+',*,*,*,*,*\n')
        else:
            f.write(word+',,,,SL,*,T,'+word+',*,*,*,*,*\n')

f.close()