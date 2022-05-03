import matplotlib.pyplot as plt
from gensim.models import CoherenceModel

def get_score(corpus, id2word, text_list)
    coherence_values = []
    perplexity_values = []
    for t in range(start, end, steps):
        lda_model = gensim.models.LdaModel(corpus=corpus, num_topics=t, id2word=id2word) # 아래랑 성능 비교하기
        # lda_model = gensim.models.wrappers.LdaMallet(mallet_path, corpus=corpus, num_topics=t, id2word=id2word)
        coherence_model = CoherenceModel(model=lda_model, texts=text_list, dictionary=id2word, topn=)
        coherence = coherence_model.get_coherence()
        coherence_values.append(coherence)
        perplexity_values.append(lda_model.log_perplexity(corpus))

    plt.plot(range(start, end, steps), coherence_values)
    plt.title('Coherence')
    plt.xlabel('num of topics')
    plt.ylabel('coherence score')

    plt.plot(range(start, end, steps), perplexity_values)
    plt.title('Perplexity')
    plt.xlabel('num of topics')
    plt.ylabel('perplexity score')

    plt.show()


