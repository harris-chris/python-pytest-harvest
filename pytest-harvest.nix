{ poetry2nix, fetchFromGitHub, setuptools-scm, git }:

let

in poetry2nix.mkPoetryApplication {
  src = ./.;
  projectDir = ./.;

  SETUPTOOLS_SCM_PRETEND_VERSION="1.10.4";

  nativeBuildInputs = [ setuptools-scm git ];

  overrides = poetry2nix.defaultPoetryOverrides.extend
    (self: super: {
      pandas = super.pandas.overridePythonAttrs
      (
        old: {
          buildInputs = (old.buildInputs or [ ]) ++ [ super.setuptools super.versioneer ];
        }
      );
    });
  }

