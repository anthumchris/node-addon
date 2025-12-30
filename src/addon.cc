#include <napi.h>

using namespace Napi;
using namespace std;

String Hello(const CallbackInfo& info) {
  Env env = info.Env();
  string name = (info.Length() > 0)
    ? " " + info[0].ToString().Utf8Value()
    : "";
  return String::New(env, "hello" + name);
}

Object Init(Env env, Object exports) {
  exports.Set(String::New(env, "hello"), Function::New(env, Hello));
  return exports;
}

NODE_API_MODULE(addon, Init)
