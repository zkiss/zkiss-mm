FROM jekyll/jekyll:3.8

ADD . /srv/jekyll/

CMD ["jekyll", "serve", "--drafts"]