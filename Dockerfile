ARG RUBY_VERSION=ruby:3.2.3
ARG NODE_VERSION=20

FROM $RUBY_VERSION
ARG RUBY_VERSION
ARG NODE_VERSION

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo
ENV BUNDLE_APP_CONFIG=/runteq_graduation_productio-/.bundle
#bundleの設定ファイルを特定の場所に保存

# セキュリティ強化のため、ca-certificatesとgnupgをインストール
# Node.jsのリポジトリを追加
RUN apt-get update -qq \
  && apt-get install -y ca-certificates curl gnupg

# 公開鍵の追加（ノードソース）
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && NODE_MAJOR=20 \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Yarnのリポジトリを追加
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarnkey.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# パッケージのインストール
RUN apt-get update -qq \
  && apt-get install -y build-essential nodejs yarn vim libmariadb-dev

RUN mkdir /runteq_graduation_productio-
WORKDIR /runteq_graduation_productio-
RUN gem install bundler
COPY Gemfile /runteq_graduation_productio-/Gemfile
COPY Gemfile.lock /runteq_graduation_productio-/Gemfile.lock
COPY Procfile /runteq_graduation_productio-/Procfile
COPY yarn.lock /runteq_graduation_productio-/yarn.lock
RUN bundle install
RUN yarn install
COPY . /runteq_graduation_productio-
CMD ["bash", "-c", "bundle exec rails s -b '0.0.0.0' -p ${PORT:-3000}"]