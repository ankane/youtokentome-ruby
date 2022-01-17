# YouTokenToMe Ruby

[YouTokenToMe](https://github.com/VKCOM/YouTokenToMe) - high performance unsupervised text tokenization - for Ruby

Learn more about [how it works](https://medium.com/@vktech/youtokentome-a-tool-for-quick-text-tokenization-from-the-vk-team-aa6341215c5a)

[![Build Status](https://github.com/ankane/youtokentome-ruby/workflows/build/badge.svg?branch=master)](https://github.com/ankane/youtokentome-ruby/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem "youtokentome"
```

## Getting Started

Dump your text to a file

```txt
Blazingly fast tokenization!
```

Train a model

```ruby
model = YouTokenToMe::BPE.train(data: "train.txt", model: "model.txt", vocab_size: 30000)
```

Load a model

```ruby
model = YouTokenToMe::BPE.new("model.txt")
```

Get vocab

```ruby
model.vocab
```

Encode

```ruby
model.encode(sentences)
```

Decode

```ruby
model.decode(ids)
```

Convert between ids and subwords

```ruby
model.subword_to_id(subword)
model.id_to_subword(id)
```

## Options

Train

```ruby
YouTokenToMe::BPE.train(
  data: "train.txt",   # path to file with training data
  model: "model.txt",  # path to where the trained model will be saved
  vocab_size: 30000,   # number of tokens in the final vocabulary
  coverage: 1.0,       # fraction of characters covered by the model
  n_threads: -1,       # number of parallel threads used to run
  pad_id: 0,           # reserved id for padding
  unk_id: 1,           # reserved id for unknown symbols
  bos_id: 2,           # reserved id for begin of sentence token
  eos_id: 3            # reserved id for end of sentence token
)
```

Encode

```ruby
model.encode(
  sentences,
  output_type: :id,    # or :subword
  bos: false,          # add "beginning of sentence" token
  eos: false,          # add "end of sentence" token
  reverse: false,      # reverse output sequence of tokens
  dropout_prob: 0.0    # BPE-dropout probability
)
```

## History

View the [changelog](https://github.com/ankane/youtokentome-ruby/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/youtokentome-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/youtokentome-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/youtokentome-ruby.git
cd youtokentome-ruby
bundle install
bundle exec rake compile
bundle exec rake test
```
