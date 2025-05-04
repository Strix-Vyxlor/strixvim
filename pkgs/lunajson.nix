{
  buildLuarocksPackage,
  fetchFromGitHub,
  fetchurl,
  luaOlder,
}:
buildLuarocksPackage {
  pname = "lunajson";
  version = "1.2.3-1";
  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/lunajson-1.2.3-1.rockspec";
      sha256 = "1zqjyd90skjhmbmrisxrlsx1wzckrxg66ha3yf2dp71p6hnblfbp";
    }).outPath;
  src = fetchFromGitHub {
    owner = "grafi-tt";
    repo = "lunajson";
    rev = "1.2.3";
    hash = "sha256-LZipetkhtScHhI78OFLVkEjpQyvdkbMM0Y2TGFQ7dvg=";
  };

  disabled = luaOlder "5.1";

  meta = {
    homepage = "https://github.com/grafi-tt/lunajson";
    description = "A strict and fast JSON parser/decoder/encoder written in pure Lua";
    license.fullName = "MIT/X11";
  };
}
