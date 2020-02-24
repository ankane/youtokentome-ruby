module YouTokenToMe
  class BPE
    def initialize(model, n_threads: -1)
      @encoder = Ext::BaseEncoder.new(model, n_threads)
    end

    def vocab_size
      @encoder.vocab_size
    end

    def vocab
      vocab = @encoder.vocab
      vocab.each do |v|
        v.force_encoding(Encoding::UTF_8)
      end
      vocab
    end

    def subword_to_id(subword)
      @encoder.subword_to_id(subword)
    end

    def id_to_subword(id)
      @encoder.id_to_subword(id)
    end

    def encode(sentences, output_type: :id, bos: false, eos: false, reverse: false, dropout_prob: 0)
      case output_type
      when :id
        @encoder.encode_as_ids(sentences, bos, eos, reverse, dropout_prob)
      when :subword
        subwords = @encoder.encode_as_subwords(sentences, bos, eos, reverse, dropout_prob)
        subwords.each do |s|
          s.each do |v|
            v.force_encoding(Encoding::UTF_8)
          end
        end
        subwords
      else
        raise ArgumentError, "Unknown output type"
      end
    end

    # TODO add ignore_ids
    def decode(ids)
      @encoder.decode(ids)
    end

    def self.train(data:, model:, vocab_size:, coverage: 1.0, n_threads: -1, pad_id: 0, unk_id: 1, bos_id: 2, eos_id: 3)
      Ext.train_bpe(data, model, vocab_size, coverage, n_threads, pad_id, unk_id, bos_id, eos_id)
      new(model, n_threads: n_threads)
    end
  end
end
