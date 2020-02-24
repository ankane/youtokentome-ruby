import youtokentome as yttm

model_path = '/tmp/model.txt'
model = yttm.BPE.train(data='test/support/train.txt', vocab_size=100, model=model_path, n_threads=1)
print(model.vocab_size())
print(model.vocab())
print(model.subword_to_id('tokenization!'))
print(model.id_to_subword(10))
print(model.decode([10, 11, 12]))
print(model.encode(['blazing']))
print(model.encode(['blazing'], output_type=yttm.OutputType.SUBWORD))
