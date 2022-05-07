import matplotlib.pyplot as plt
import gensim
from gensim.models import CoherenceModel

def get_score(corpus, id2word, text_list, start, end, steps):
    coherence_values = []
    perplexity_values = []
    for t in range(start, end, steps):
        lda_model = gensim.models.LdaModel(corpus=corpus, num_topics=t, id2word=id2word) # 아래랑 성능 비교하기
        # lda_model = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=t, id2word=id2word)
        coherence_model = CoherenceModel(model=lda_model, texts=text_list, dictionary=id2word, topn=3)
        coherence = coherence_model.get_coherence()
        coherence_values.append(coherence)
        perplexity_values.append(lda_model.log_perplexity(corpus))

    plt.plot(range(start, end, steps), coherence_values)
    plt.title('Coherence')
    plt.xlabel('num of topics')
    plt.ylabel('coherence score')
    plt.show()
    # 높을수록 의미론적 일관성 높음
    
    plt.plot(range(start, end, steps), perplexity_values)
    plt.title('Perplexity')
    plt.xlabel('num of topics')
    plt.ylabel('perplexity score')
    plt.show()
    # 즉 특정 확률 모델이 실제도 관측되는 값을 어마나 잘 예측하는지를 뜻합니다. Perlexity값이 작으면 토픽모델이 문서를 잘 반영된다고 알 수 있습니다. 따라서 작아지는것이 중요합니다.
    


