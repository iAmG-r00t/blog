# Hydejack-blog.nix
with (import <nixpkgs> {});

stdenv.mkDerivation {
	name = "thblog";
	buildInputs = [bundler ruby];

	shellHook = ''
		bundle install
		alias blog="bundle exec jekyll serve"
		export START_BLOG="Run 'bundle exec jekyll serve' to view the blog"
		echo $START_BLOG
	'';
}
