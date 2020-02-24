require_relative "test_helper"

class BPETest < Minitest::Test
  def test_works
    model_path = "#{Dir.mktmpdir}/model.txt"

    # train
    model = YouTokenToMe::BPE.train(
      data: "test/support/train.txt",
      model: model_path,
      vocab_size: 100,
      n_threads: 1
    )
    assert_equal 46, model.vocab_size

    # load
    model = YouTokenToMe::BPE.new(model_path)

    assert_equal 46, model.vocab_size
    expected = ["<PAD>", "<UNK>", "<BOS>", "<EOS>", "▁", "t", "n", "i", "a", "z", "o", "l", "y", "s", "k", "g", "f", "e", "B", "!", "fa", "ly", "fas", "gly", "fast", "ngly", "▁fast", "ingly", "zingly", "ti", "azingly", "tio", "lazingly", "tion", "Blazingly", "tion!", "▁Blazingly", "ation!", "to", "zation!", "tok", "ization!", "toke", "nization!", "tokenization!", "▁tokenization!"]
    assert_equal expected, model.vocab
    assert_equal 44, model.subword_to_id("tokenization!")
    assert_equal "o", model.id_to_subword(10)
    assert_equal ["oly"], model.decode([10, 11, 12])
    assert_equal [[4, 1, 11, 8, 9, 7, 6, 15]], model.encode(["blazing"])
    assert_equal [["▁", "b", "l", "a", "z", "i", "n", "g"]], model.encode(["blazing"], output_type: :subword)
  end

  def test_invalid_data
    error = assert_raises(ArgumentError) do
      YouTokenToMe::BPE.train(
        data: "invalid.txt",
        model: "model.txt",
        vocab_size: 100
      )
    end
    assert_equal "Failed to open file: invalid.txt", error.message
  end
end
