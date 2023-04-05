# Wobserver NG

This repo is an effort of keeping the original [wobserver](https://github.com/shinyscorpion/wobserver) updated with latest version of Elixir.

Original [wobserver](https://github.com/shinyscorpion/wobserver) is a wonderful project making remotely inspecting Elixir developing easy, but it has stopped updating itself after 2017. Both Elixir the language and Erlang OTP platform have changed a lot, so need some effort to change it and make it work again. This repo is targeting of doing that.

The current effort is focusing on making it work with
* Elixir ~ v1.14.x
* Erlang/OTP 25

All functions are kept the same as origianl project, thus for knowing what it is, how to use it, and browse all functionalities, please refer to [origianl README](https://github.com/liyu1981/wobserver-ng/blob/master/README.orig.md) or simply original [wobserver repo](https://github.com/shinyscorpion/wobserver).

This project is licensed with same MIT license as in original wobserver project.

## How to use it

I have published this repo [with name "wobserver_ng" to Hex.pm](https://hex.pm/packages/wobserver_ng/). So if want to use it in your project, simply add `{:wobserver_ng, "~> 1.14"}` to your `deps` function in `mix.exs`, like below

```Elixir
  defp deps do
    [
      ...,
      {:wobserver_ng, "~> 1.14"},
      ...
    ]
  end
```