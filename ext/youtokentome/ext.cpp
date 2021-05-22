// youtokentome
#include <bpe.h>
#include <utils.h>

// rice
#include <rice/rice.hpp>
#include <rice/stl.hpp>

using Rice::Array;
using Rice::Module;
using Rice::Object;

void check_status(vkcom::Status& status) {
  if (!status.ok()) {
    throw std::invalid_argument(status.error_message());
  }
}

namespace Rice::detail
{
  template<>
  class To_Ruby<std::vector<std::string>>
  {
  public:
    VALUE convert(std::vector<std::string> const & x)
    {
      Array ret;
      for (auto& v : x) {
        ret.push(v);
      }
      return ret;
    }
  };

  template<>
  class From_Ruby<std::vector<int>>
  {
  public:
    std::vector<int> convert(VALUE x)
    {
      Array a = Array(x);
      std::vector<int> ret;
      ret.reserve(a.size());
      for (const auto& v : a) {
        ret.push_back(From_Ruby<int>().convert(v.value()));
      }
      return ret;
    }
  };

  template<>
  class From_Ruby<std::vector<std::string>>
  {
  public:
    std::vector<std::string> convert(VALUE x)
    {
      Array a = Array(x);
      std::vector<std::string> ret;
      ret.reserve(a.size());
      for (const auto& v : a) {
        ret.push_back(From_Ruby<std::string>().convert(v.value()));
      }
      return ret;
    }
  };
}

extern "C"
void Init_ext()
{
  auto rb_mYouTokenToMe = Rice::define_module("YouTokenToMe");
  auto rb_mExt = Rice::define_module_under(rb_mYouTokenToMe, "Ext")
    .define_singleton_function(
      "train_bpe",
      [](const std::string& input_path, const std::string& model_path, int vocab_size, double coverage,
          int n_threads, int pad_id, int unk_id, int bos_id, int eos_id) {

        vkcom::SpecialTokens special_tokens(pad_id, unk_id, bos_id, eos_id);
        vkcom::BpeConfig config(coverage, n_threads, special_tokens);
        auto status = vkcom::train_bpe(input_path, model_path, vocab_size, config);
        check_status(status);
      });

  Rice::define_class_under<vkcom::BaseEncoder>(rb_mExt, "BaseEncoder")
    .define_method("vocab_size", &vkcom::BaseEncoder::vocab_size)
    .define_method("subword_to_id", &vkcom::BaseEncoder::subword_to_id)
    .define_method(
      "id_to_subword",
      [](vkcom::BaseEncoder& self, int id) {
        std::string subword;
        auto status = self.id_to_subword(id, &subword);
        check_status(status);
        return subword;
      })
    .define_method(
      "decode",
      [](vkcom::BaseEncoder& self, std::vector<int> ids) {
        std::string sentence;
        const std::unordered_set<int> ignore_ids;
        auto status = self.decode(ids, &sentence, &ignore_ids);
        check_status(status);

        Array ret;
        ret.push(sentence);
        return ret;
      })
    .define_method(
      "encode_as_ids",
      [](vkcom::BaseEncoder& self, std::vector<std::string> sentences, bool bos, bool eos, bool reverse, double dropout_prob) {
        std::vector<std::vector<int>> ids;
        auto status = self.encode_as_ids(sentences, &ids, bos, eos, reverse, dropout_prob);
        check_status(status);

        Array ret;
        for (auto& v : ids) {
          Array r;
          for (auto& v2 : v) {
            r.push(v2);
          }
          ret.push(r);
        }
        return ret;
      })
    .define_method(
      "encode_as_subwords",
      [](vkcom::BaseEncoder& self, std::vector<std::string> sentences, bool bos, bool eos, bool reverse, double dropout_prob) {
        std::vector<std::vector<std::string>> subwords;
        auto status = self.encode_as_subwords(sentences, &subwords, bos, eos, reverse, dropout_prob);
        check_status(status);

        Array ret;
        for (auto& v : subwords) {
          Array r;
          for (auto& v2 : v) {
            r.push(v2);
          }
          ret.push(r);
        }
        return ret;
      })
    .define_method("vocab", &vkcom::BaseEncoder::vocabulary)
    .define_singleton_function(
      "new",
      [](const std::string& model_path, int n_threads) {
        auto status = vkcom::Status();
        vkcom::BaseEncoder encoder(model_path, n_threads, &status);
        check_status(status);
        return encoder;
      });
}
