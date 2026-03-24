{
  stdenv,
}:
stdenv.mkDerivation {
  pname = "hello-woof";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/hello-woof <<EOF
    #!/usr/bin/env bash
    echo "hello woof"
    EOF
    chmod +x $out/bin/hello-woof
  '';
}
