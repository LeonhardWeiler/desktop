{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
}:
rustPlatform.buildRustPackage rec {
  pname = "eitype";
  version = "0.2.2";
  src = fetchFromGitHub {
    owner = "Adam-D-Lewis";
    repo = "eitype";
    tag = version;
    hash = "sha256-s5g6METDi8/jPEwZursorYWN8X96VlyVPtd8dCCVIlw=";
  };
  cargoHash = "sha256-k0JU3Y83aPHgQpyiG6DXxBzdYSMOmH42kPCxXWtNtkQ=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxkbcommon ];
  doCheck = false;
}
