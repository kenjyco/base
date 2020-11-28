# Source this file

REPOS_DIR="$HOME/repos"
OPEN_SOURCE_REPOS_DIR="$REPOS_DIR/opensource"
OPEN_SOURCE_ALGORITHMS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/algorithms"
OPEN_SOURCE_BOOKS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/books"
OPEN_SOURCE_C_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/c"
OPEN_SOURCE_CPP_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/c++"
OPEN_SOURCE_DART_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/dart"
OPEN_SOURCE_DOCKERFILE_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/dockerfiles"
OPEN_SOURCE_DOCS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/docs"
OPEN_SOURCE_ELIXIR_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/elixir"
OPEN_SOURCE_ERLANG_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/erlang"
OPEN_SOURCE_GO_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/go"
OPEN_SOURCE_HASKELL_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/haskell"
OPEN_SOURCE_JAVA_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/java"
OPEN_SOURCE_JAVASCRIPT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/javascript"
OPEN_SOURCE_JULIA_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/julia"
OPEN_SOURCE_JUPYTER_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/jupyter"
OPEN_SOURCE_KOTLIN_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/kotlin"
OPEN_SOURCE_LUA_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/lua"
OPEN_SOURCE_PYTHON_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/python"
OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/python_async"
OPEN_SOURCE_RUBY_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/ruby"
OPEN_SOURCE_RUST_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/rust"
OPEN_SOURCE_SASS_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/sass"
OPEN_SOURCE_SCALA_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/scala"
OPEN_SOURCE_SHELL_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/shell"
OPEN_SOURCE_SWIFT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/swift"
OPEN_SOURCE_TYPESCRIPT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/typescript"
OPEN_SOURCE_VIMSCRIPT_REPOS_DIR="$OPEN_SOURCE_REPOS_DIR/vimscript"

OPEN_SOURCE_ALGORITHMS_REPOS=(
    https://github.com/TheAlgorithms/Algorithms-Explanation
    https://github.com/TheAlgorithms/C
    https://github.com/TheAlgorithms/C-Plus-Plus
    https://github.com/TheAlgorithms/Go
    https://github.com/TheAlgorithms/Java
    https://github.com/TheAlgorithms/Javascript
    https://github.com/TheAlgorithms/Python
    https://github.com/TheAlgorithms/Ruby
)

OPEN_SOURCE_BOOKS_REPOS=(
    https://github.com/abhirockzz/practical-redis
    https://github.com/bagder/everything-curl
    https://github.com/git/git-scm.com
    https://github.com/josiahcarlson/redis-in-action
    https://github.com/karlseguin/the-little-mongodb-book
    https://github.com/karlseguin/the-little-redis-book
    https://github.com/redis-essentials/book
    https://github.com/ruslo/CGold
    https://github.com/swaroopch/byte-of-vim
)

OPEN_SOURCE_C_REPOS=(
    https://g.blicky.net/ncdu.git
    https://gcc.gnu.org/git/gcc.git
    https://git.savannah.gnu.org/git/bash.git
    https://git.savannah.gnu.org/git/basics.git
    https://git.savannah.gnu.org/git/coreutils.git
    https://git.savannah.gnu.org/git/findutils.git
    https://git.savannah.gnu.org/git/gawk.git
    https://git.savannah.gnu.org/git/make.git
    https://git.savannah.gnu.org/git/sed.git
    https://git.savannah.gnu.org/git/tar.git
    https://git.savannah.gnu.org/git/wget.git
    https://github.com/AndyA/rsync
    https://github.com/Gnucash/gnucash
    https://github.com/JoshData/historical-state-population-csv
    https://github.com/Netflix/dynomite
    https://github.com/Perl/perl5
    https://github.com/X0rg/CPU-X
    https://github.com/antirez/load81
    https://github.com/antirez/rax
    https://github.com/antirez/redis
    https://github.com/awesomeWM/awesome
    https://github.com/curl/curl
    https://github.com/git/git
    https://github.com/irssi/irssi
    https://github.com/jarun/dslib
    https://github.com/jarun/keysniffer
    https://github.com/jarun/nnn
    https://github.com/jedisct1/libsodium
    https://github.com/jonas/tig
    https://github.com/libevent/libevent
    https://github.com/libuv/libuv
    https://github.com/lua/lua
    https://github.com/mirror/busybox
    https://github.com/mirror/dd-wrt
    https://github.com/mirror/ncurses
    https://github.com/mirror/xmlrpc-c
    https://github.com/nanomsg/nanomsg
    https://github.com/nanomsg/nng
    https://github.com/nginx/nginx
    https://github.com/openai/retro
    https://github.com/openssh/openssh-portable
    https://github.com/pipelinedb/pipelinedb
    https://github.com/postgres/postgres
    https://github.com/profanity-im/profanity
    https://github.com/python/cpython
    https://github.com/python/devguide
    https://github.com/ruby/ruby
    https://github.com/signalwire/freeswitch
    https://github.com/stedolan/jq
    https://github.com/tmux/tmux
    https://github.com/tony/NCURSES-Programming-HOWTO-examples
    https://github.com/torvalds/linux
    https://github.com/twitter/pelikan
    https://github.com/twitter/twemproxy
    https://github.com/uber/h3
    https://github.com/vim/vim
    https://github.com/wmcbrine/PDCurses
    https://github.com/zsh-users/zsh
    https://gitlab.com/libvirt/libvirt
    https://gitlab.gnome.org/GNOME/libxml2.git
    https://gitlab.gnome.org/GNOME/libxslt.git
    https://gitlab.kitware.com/cmake/cmake
    https://repo.or.cz/sqlite.git
    https://sourceware.org/git/binutils-gdb.git
    https://sourceware.org/git/dm.git
    https://sourceware.org/git/glibc.git
    https://sourceware.org/git/lvm2.git
)

OPEN_SOURCE_CPP_REPOS=(
    https://github.com/alembic/alembic
    https://github.com/apache/arrow
    https://github.com/apple/swift
    https://github.com/bast/cmake-example
    https://github.com/bitcoin/bitcoin
    https://github.com/blakesmith/embedded
    https://github.com/fish-shell/fish-shell
    https://github.com/grpc/grpc
    https://github.com/jarulraj/sqlcheck
    https://github.com/mongodb/mongo
    https://github.com/nodejs/node
    https://github.com/protocolbuffers/protobuf
    https://github.com/sqlitebrowser/sqlitebrowser
    https://github.com/tesseract-ocr/tesseract
    https://github.com/ttroy50/cmake-examples
    https://github.com/v8/v8
    https://github.com/zeromq/libzmq
)

OPEN_SOURCE_DART_REPOS=(
    https://github.com/dart-lang/build
    https://github.com/dart-lang/cli_util
    https://github.com/dart-lang/dart-pad
    https://github.com/dart-lang/sdk
    https://github.com/dart-lang/usage
    https://github.com/flutter/flutter
    https://github.com/flutter/samples
)

OPEN_SOURCE_DOCKERFILE_REPOS=(
    https://github.com/alpine-docker/git
    https://github.com/gliderlabs/docker-alpine
    https://github.com/jessfraz/dockerfiles
    https://github.com/pyca/infra
)

OPEN_SOURCE_DOCS_REPOS=(
    https://github.com/0xAX/linux-insides
    https://github.com/30-seconds/30-seconds-of-code
    https://github.com/APIs-guru/graphql-apis
    https://github.com/Hack-with-Github/Awesome-Hacking
    https://github.com/JamzyWang/awesome-redis
    https://github.com/adomokos/Vim-Katas
    https://github.com/airbnb/javascript
    https://github.com/alebcay/awesome-shell
    https://github.com/avelino/awesome-go
    https://github.com/awesomedata/awesome-public-datasets
    https://github.com/bayandin/awesome-awesomeness
    https://github.com/bitcoinbook/bitcoinbook
    https://github.com/bjeanes/culture
    https://github.com/braydie/HowToBeAProgrammer
    https://github.com/charlax/professional-programming
    https://github.com/chentsulin/awesome-graphql
    https://github.com/chubin/awesome-console-services
    https://github.com/cjbarber/ToolsOfTheTrade
    https://github.com/danistefanovic/build-your-own-x
    https://github.com/donnemartin/system-design-primer
    https://github.com/drobakowski/awesome-erlang
    https://github.com/droptheplot/awesome-phoenix
    https://github.com/dylanaraps/pure-bash-bible
    https://github.com/ericdouglas/ES6-Learning
    https://github.com/getify/You-Dont-Know-JS
    https://github.com/git-tips/tips
    https://github.com/golang-standards/project-layout
    https://github.com/gto76/python-cheatsheet
    https://github.com/h4cc/awesome-elixir
    https://github.com/hubtee/awesome-opensource-documents
    https://github.com/jlevy/the-art-of-command-line
    https://github.com/jorgebucaran/awesome-fish
    https://github.com/josephmisiti/awesome-machine-learning
    https://github.com/kahun/awesome-sysadmin
    https://github.com/kilimchoi/engineering-blogs
    https://github.com/learnbyexample/Command-line-text-processing
    https://github.com/learnbyexample/Linux_command_line
    https://github.com/learnbyexample/Perl_intro
    https://github.com/learnbyexample/Python_Basics
    https://github.com/learnbyexample/Ruby_Scripting
    https://github.com/learnbyexample/learn_gnuawk
    https://github.com/learnbyexample/learn_gnused
    https://github.com/learnbyexample/py_regular_expressions
    https://github.com/learnbyexample/scripting_course
    https://github.com/learnbyexample/vim_reference
    https://github.com/letsencrypt/website
    https://github.com/lk-geimfari/awesomo
    https://github.com/luong-komorebi/Awesome-Linux-Software
    https://github.com/machinelearningmindset/TensorFlow-Course
    https://github.com/machinelearningmindset/machine-learning-course
    https://github.com/mhinz/vim-galore
    https://github.com/miloyip/game-programmer
    https://github.com/mtdvio/every-programmer-should-know
    https://github.com/nefe/You-Dont-Need-jQuery
    https://github.com/onqtam/awesome-cmake
    https://github.com/ossu/computer-science
    https://github.com/papers-we-love/papers-we-love
    https://github.com/public-apis/public-apis
    https://github.com/pytorch/examples
    https://github.com/satwikkansal/wtfpython
    https://github.com/sdmg15/Best-websites-a-programmer-should-visit
    https://github.com/sindresorhus/awesome
    https://github.com/sindresorhus/awesome-nodejs
    https://github.com/sorrycc/awesome-javascript
    https://github.com/swisskyrepo/PayloadsAllTheThings
    https://github.com/thoughtbot/guides
    https://github.com/trimstray/the-book-of-secret-knowledge
    https://github.com/tuvtran/project-based-learning
    https://github.com/unitedstates/APIs
    https://github.com/unitedstates/congress-legislators
    https://github.com/unitedstates/contact-congress
    https://github.com/unitedstates/districts
    https://github.com/unitedstates/glossary
    https://github.com/vinta/awesome-python
    https://github.com/vuejs/awesome-vue
    https://github.com/you-dont-need/You-Dont-Need-JavaScript
    https://github.com/ziishaned/learn-regex
)

OPEN_SOURCE_ELIXIR_REPOS=(
    https://github.com/absinthe-graphql/absinthe
    https://github.com/adoptoposs/adoptoposs
    https://github.com/christopheradams/elixir_style_guide
    https://github.com/elixir-lang/elixir
    https://github.com/elixirschool/elixirschool
    https://github.com/gothinkster/elixir-phoenix-realworld-example-app
    https://github.com/grych/drab
    https://github.com/khusnetdinov/loki
    https://github.com/operable/cog
    https://github.com/phoenixframework/phoenix
    https://github.com/rrrene/credo
    https://github.com/thoughtbot/bamboo
)

OPEN_SOURCE_ERLANG_REPOS=(
    https://github.com/rabbitmq/rabbitmq-server
    https://github.com/erlang/otp
    https://github.com/erlang/docker-erlang-example
)

OPEN_SOURCE_GO_REPOS=(
    https://github.com/99designs/gqlgen
    https://github.com/Netflix/chaosmonkey
    https://github.com/apex/up
    https://github.com/caddyserver/caddy
    https://github.com/dgraph-io/dgraph
    https://github.com/docker/docker-ce
    https://github.com/docker/machine
    https://github.com/elastic/beats
    https://github.com/etcd-io/etcd
    https://github.com/flynn/flynn
    https://github.com/gliderlabs/logspout
    https://github.com/gliderlabs/ssh
    https://github.com/go-pg/pg
    https://github.com/gohugoio/hugo
    https://github.com/golang/go
    https://github.com/golang/net
    https://github.com/golang/tools
    https://github.com/gomodule/redigo
    https://github.com/gorilla/handlers
    https://github.com/gorilla/mux
    https://github.com/gorilla/sessions
    https://github.com/gorilla/websocket
    https://github.com/grafana/grafana
    https://github.com/graphql-go/graphql
    https://github.com/grpc/grpc-go
    https://github.com/hashicorp/consul
    https://github.com/hashicorp/packer
    https://github.com/hashicorp/terraform
    https://github.com/hashicorp/vault
    https://github.com/helm/charts
    https://github.com/helm/helm
    https://github.com/influxdata/telegraf
    https://github.com/istio/istio
    https://github.com/itchyny/gojq
    https://github.com/jwilder/docker-gen
    https://github.com/keybase/client
    https://github.com/kubeless/kubeless
    https://github.com/kubernetes-sigs/kind
    https://github.com/kubernetes/kubernetes
    https://github.com/kubernetes/minikube
    https://github.com/letsencrypt/boulder
    https://github.com/linkerd/linkerd2
    https://github.com/moby/moby
    https://github.com/mongodb/mongo-go-driver
    https://github.com/nanomsg/mangos
    https://github.com/pebbe/zmq4
    https://github.com/pingcap/tidb
    https://github.com/rancher/k3s
    https://github.com/rancher/rancher
    https://github.com/uber/aresdb
    https://github.com/uber/kraken
    https://github.com/uber/peloton
    https://github.com/uber/prototool
    https://github.com/xo/usql
)

OPEN_SOURCE_HASKELL_REPOS=(
    https://github.com/jgm/pandoc
)

OPEN_SOURCE_JAVA_REPOS=(
    https://github.com/Netflix/SimianArmy
    https://github.com/Netflix/eureka
    https://github.com/ReactiveX/RxAndroid
    https://github.com/ReactiveX/RxJava
    https://github.com/SeleniumHQ/selenium
    https://github.com/Snailclimb/JavaGuide
    https://github.com/alibaba/fastjson
    https://github.com/apache/dubbo
    https://github.com/apache/groovy
    https://github.com/apache/kafka
    https://github.com/apache/lucene-solr
    https://github.com/apache/tomcat
    https://github.com/apache/zeppelin
    https://github.com/bazelbuild/bazel
    https://github.com/dbeaver/dbeaver
    https://github.com/elastic/elasticsearch
    https://github.com/google/guava
    https://github.com/google/rejoiner
    https://github.com/gradle/gradle
    https://github.com/graphql-java/graphql-java
    https://github.com/greenrobot/EventBus
    https://github.com/iluwatar/java-design-patterns
    https://github.com/jenkinsci/jenkins
    # https://github.com/mockito/mockit
    https://github.com/seata/seata
    https://github.com/square/okhttp
    https://github.com/square/retrofit
    https://github.com/termux/termux-app
    https://github.com/twosigma/beakerx
    https://github.com/uber/AthenaX
)

OPEN_SOURCE_JAVASCRIPT_REPOS=(
    https://github.com/APIs-guru/openapi-directory
    https://github.com/Kong/insomnia
    https://github.com/LLK/scratch-blocks
    https://github.com/LLK/scratch-gui
    https://github.com/LLK/scratch-render
    https://github.com/LLK/scratch-vm
    https://github.com/LLK/scratch-www
    https://github.com/LLK/scratchjr
    https://github.com/Leaflet/Leaflet
    https://github.com/Netflix/falcor
    https://github.com/Netflix/pollyjs
    https://github.com/Netflix/vector
    https://github.com/Netflix/vizceral
    https://github.com/NickCarneiro/curlconverter
    https://github.com/Unitech/pm2
    https://github.com/VulcanJS/Vulcan
    https://github.com/alpinejs/alpine
    https://github.com/angular/angular-phonecat
    https://github.com/api-platform/api-platform
    https://github.com/avajs/ava
    https://github.com/babel/babel
    https://github.com/bookshelf/bookshelf
    https://github.com/chalk/chalk
    https://github.com/chartjs/Chart.js
    https://github.com/cypress-io/cypress
    https://github.com/d3/d3
    https://github.com/eslint/eslint
    https://github.com/expressjs/express
    https://github.com/facebook/create-react-app
    https://github.com/facebook/react
    https://github.com/facebook/react-native
    https://github.com/freeCodeCamp/freeCodeCamp
    https://github.com/gatsbyjs/gatsby
    https://github.com/graphile/postgraphile
    https://github.com/graphite-project/graphite-web
    https://github.com/graphql/express-graphql
    https://github.com/hakimel/reveal.js
    https://github.com/hasura/graphql-engine
    https://github.com/hoppscotch/hoppscotch
    https://github.com/hubotio/hubot
    https://github.com/jfo8000/ScratchJr-Desktop
    https://github.com/knex/knex
    https://github.com/kriasoft/react-starter-kit
    https://github.com/lodash/lodash
    https://github.com/parse-community/parse-dashboard
    https://github.com/parse-community/parse-server
    https://github.com/pinterest/bonsai
    https://github.com/pinterest/teletraan
    https://github.com/postmanlabs/newman
    https://github.com/postmanlabs/postman-collection
    https://github.com/postmanlabs/postman-docs
    https://github.com/prettier/prettier
    https://github.com/rickbergfalk/sqlpad
    https://github.com/sequelize/sequelize
    https://github.com/serverless/examples
    https://github.com/serverless/serverless
    https://github.com/serverless/serverless-graphql
    https://github.com/serverless/serverless-kubeless
    https://github.com/socketio/socket.io
    https://github.com/statsd/statsd
    https://github.com/strapi/strapi
    https://github.com/tj/commander.js
    https://github.com/twitter/hogan.js
    https://github.com/twitter/labella.js
    https://github.com/twitter/typeahead.js
    https://github.com/typicode/json-server
    https://github.com/uber/baseweb
    https://github.com/uber/h3-js
    https://github.com/uber/in-n-out
    https://github.com/uber/xviz
    https://github.com/unitedstates/citation
    https://github.com/unitedstates/uslaw.link
    https://github.com/vuejs/vue
    https://github.com/vuejs/vue-apollo
    https://github.com/webpack/webpack
    https://github.com/webpack/webpack-dev-server
    https://github.com/winstonjs/winston
    https://github.com/xojs/xo
    https://github.com/yarnpkg/yarn
    https://github.com/yhat/rodeo
)

OPEN_SOURCE_JULIA_REPOS=(
    https://github.com/FluxML/Flux.jl
    https://github.com/JuliaLang/IJulia.jl
    https://github.com/JuliaLang/julia
)

OPEN_SOURCE_JUPYTER_REPOS=(
    https://github.com/binder-examples/requirements
)

OPEN_SOURCE_KOTLIN_REPOS=(
    https://github.com/JetBrains/kotlin-native
    https://github.com/Kotlin/coroutines-examples
    https://github.com/Kotlin/kotlin-examples
    https://github.com/Kotlin/kotlin-fullstack-sample
    https://github.com/Kotlin/kotlinx.coroutines
)

OPEN_SOURCE_LUA_REPOS=(
    https://github.com/Kong/kong
    https://github.com/twitter/torch-dataset
    https://github.com/twitter/torch-distlearn
)

OPEN_SOURCE_PYTHON_REPOS=(
    https://github.com/JoshData/python-email-validator
    https://github.com/Julian/jsonschema
    https://github.com/Legrandin/pycryptodome
    https://github.com/MagicStack/httptools
    https://github.com/Mailu/Mailu
    https://github.com/Miserlou/Zappa
    https://github.com/Netflix/aminator
    https://github.com/Netflix/bless
    https://github.com/Netflix/dispatch
    https://github.com/Netflix/flamescope
    https://github.com/Netflix/hubcommander
    https://github.com/Netflix/lemur
    https://github.com/Netflix/metaflow
    https://github.com/Netflix/security_monkey
    https://github.com/Netflix/vmaf
    https://github.com/Supervisor/supervisor
    https://github.com/Zulko/moviepy
    https://github.com/ageitgey/face_recognition
    https://github.com/andymccurdy/redis-py
    https://github.com/ansible/ansible
    https://github.com/apache/airflow
    https://github.com/asciinema/asciinema
    https://github.com/aws/aws-cli
    https://github.com/aws/chalice
    https://github.com/benoitc/gaffer
    https://github.com/benoitc/gunicorn
    https://github.com/benoitc/http-parser
    https://github.com/bokeh/bokeh
    https://github.com/boto/boto3
    https://github.com/bottlepy/bottle
    https://github.com/certbot/certbot
    https://github.com/chubin/cheat.sh
    https://github.com/chubin/late.nz
    https://github.com/chubin/rate.sx
    https://github.com/chubin/wttr.in
    https://github.com/coleifer/peewee
    https://github.com/coleifer/walrus
    https://github.com/conda/conda
    https://github.com/cython/cython
    https://github.com/davidsandberg/facenet
    https://github.com/dbader/schedule
    https://github.com/dbcli/litecli
    https://github.com/dbcli/mycli
    https://github.com/dbcli/pgcli
    https://github.com/deepfakes/faceswap
    https://github.com/deepmind/sonnet
    https://github.com/django/channels
    https://github.com/django/channels_redis
    https://github.com/django/django
    https://github.com/docker/compose
    https://github.com/docopt/docopt
    https://github.com/donnemartin/data-science-ipython-notebooks
    https://github.com/edgedb/edgedb
    https://github.com/elastic/elasticsearch-py
    https://github.com/encode/django-rest-framework
    https://github.com/eriklindernoren/ML-From-Scratch
    https://github.com/fabric/fabric
    https://github.com/facebook/prophet
    https://github.com/faif/python-patterns
    https://github.com/geopy/geopy
    https://github.com/getsentry/sentry
    https://github.com/gleitz/howdoi
    https://github.com/google-research/bert
    https://github.com/google-research/google-research
    https://github.com/google/python-fire
    https://github.com/graphql-python/graphene
    https://github.com/graphql-python/graphene-django
    https://github.com/home-assistant/core
    https://github.com/huggingface/transformers
    https://github.com/ipython/ipython
    https://github.com/jakubroztocil/httpie
    https://github.com/jarun/buku
    https://github.com/jarun/ddgr
    https://github.com/jarun/googler
    https://github.com/jarun/imgp
    https://github.com/jarun/pdd
    https://github.com/joke2k/faker
    https://github.com/jpadilla/pyjwt
    https://github.com/jupyter/jupyter
    https://github.com/jupyter/nbconvert
    https://github.com/jupyter/notebook
    https://github.com/jupyterhub/binderhub
    https://github.com/jupyterhub/jupyterhub
    https://github.com/jupyterhub/the-littlest-jupyterhub
    https://github.com/keon/algorithms
    https://github.com/keras-team/keras
    https://github.com/kivy/kivy
    https://github.com/kivy/python-for-android
    https://github.com/localstack/localstack
    https://github.com/locustio/locust
    https://github.com/lxml/lxml
    https://github.com/mail-in-a-box/mailinabox
    https://github.com/marshmallow-code/marshmallow
    https://github.com/matplotlib/matplotlib
    https://github.com/mirumee/saleor
    https://github.com/mitmproxy/mitmproxy
    https://github.com/mongodb/mongo-python-driver
    https://github.com/mvantellingen/python-zeep
    https://github.com/mwaskom/seaborn
    https://github.com/nicolargo/glances
    https://github.com/nltk/nltk
    https://github.com/numpy/numpy
    https://github.com/odoo/odoo
    https://github.com/openai/gym
    https://github.com/pallets/click
    https://github.com/pallets/flask
    https://github.com/pallets/jinja
    https://github.com/pandas-dev/pandas
    https://github.com/paramiko/paramiko
    https://github.com/pinterest/mysql_utils
    https://github.com/postmanlabs/httpbin
    https://github.com/powerline/powerline
    https://github.com/psf/black
    https://github.com/psf/requests
    https://github.com/psycopg/psycopg2
    https://github.com/pyca/bcrypt
    https://github.com/pyca/cryptography
    https://github.com/pyca/pyopenssl
    https://github.com/pyeve/eve
    https://github.com/pytest-dev/pytest
    https://github.com/python-pillow/Pillow
    https://github.com/python-poetry/poetry
    https://github.com/python-telegram-bot/python-telegram-bot
    https://github.com/pytorch/examples
    https://github.com/pytorch/pytorch
    https://github.com/quantopian/pyfolio
    https://github.com/quantopian/qdb
    https://github.com/quantopian/qgrid
    https://github.com/quantopian/research_public
    https://github.com/quantopian/zipline
    https://github.com/ray-project/ray
    https://github.com/ranger/ranger
    https://github.com/readthedocs/readthedocs.org
    https://github.com/rq/rq
    https://github.com/sanand0/xmljson
    https://github.com/scikit-learn/scikit-learn
    https://github.com/scrapy/scrapy
    https://github.com/seatgeek/fuzzywuzzy
    https://github.com/sloria/TextBlob
    https://github.com/soimort/you-get
    https://github.com/sovereign/sovereign
    https://github.com/spotify/luigi
    https://github.com/sqlalchemy/alembic
    https://github.com/sqlalchemy/sqlalchemy
    https://github.com/sqlmapproject/sqlmap
    https://github.com/sshuttle/sshuttle
    https://github.com/stub42/pytz
    https://github.com/sympy/sympy
    https://github.com/tensorflow/magenta
    https://github.com/tensorflow/models
    https://github.com/tensorflow/tensor2tensor
    https://github.com/tensorflow/tensorflow
    https://github.com/thumbor/thumbor
    https://github.com/tox-dev/tox
    https://github.com/tqdm/tqdm
    https://github.com/trailofbits/algo
    https://github.com/uber/h3-py
    https://github.com/uber/h3-py-notebooks
    https://github.com/uber/focuson
    https://github.com/uber/ludwig
    https://github.com/ubuntu/microk8s
    https://github.com/ultrajson/ultrajson
    https://github.com/unitedstates/congress
    https://github.com/unitedstates/python-us
    https://github.com/warner/magic-wormhole
    https://github.com/ycm-core/YouCompleteMe
    # https://github.com/ytdl-org/youtube-dl
    https://github.com/yunjey/pytorch-tutorial
    https://github.com/zulip/zulip
)

OPEN_SOURCE_PYTHON_ASYNC_REPOS=(
    https://github.com/MagicStack/asyncpg
    https://github.com/MagicStack/uvloop
    https://github.com/aio-libs/aiobotocore
    https://github.com/aio-libs/aiohttp
    https://github.com/aio-libs/aioredis
    https://github.com/ashleysommer/sanic-cors
    https://github.com/encode/starlette
    https://github.com/huge-success/sanic
    https://gitlab.com/pgjones/hypercorn
    https://gitlab.com/pgjones/quart
    https://github.com/taoufik07/responder
    https://github.com/vibora-io/vibora
)

OPEN_SOURCE_RUBY_REPOS=(
    https://github.com/Homebrew/brew
    https://github.com/Homebrew/homebrew-bundle
    https://github.com/Homebrew/homebrew-cask
    https://github.com/Homebrew/homebrew-core
    https://github.com/Homebrew/homebrew-services
    https://github.com/Homebrew/linuxbrew-core
    https://github.com/Netflix/fast_jsonapi
    https://github.com/Shopify/liquid
    https://github.com/blakesmith/flamethrower
    https://github.com/capistrano/capistrano
    https://github.com/capistrano/sshkit
    https://github.com/discourse/discourse
    https://github.com/elastic/logstash
    https://github.com/faker-ruby/faker
    https://github.com/fastlane/fastlane
    https://github.com/fluent/fluentd
    https://github.com/freeCodeCamp/devdocs
    https://github.com/gollum/gollum
    https://github.com/hashicorp/vagrant
    https://github.com/heartcombo/devise
    https://github.com/jekyll/jekyll
    https://github.com/mperham/sidekiq
    https://github.com/mustache/mustache
    https://github.com/pry/pry
    https://github.com/rails/rails
    https://github.com/resque/resque
    https://github.com/rmosolgo/graphql-ruby
    https://github.com/sinatra/sinatra
    https://github.com/tmuxinator/tmuxinator
    https://github.com/tootsuite/mastodon
)

OPEN_SOURCE_RUST_REPOS=(
    https://github.com/RedBeardLab/rediSQL
    https://github.com/actix/actix-web
    https://github.com/erickt/rust-zmq
    https://github.com/hyperium/hyper
    https://github.com/gyscos/cursive
    https://github.com/mitsuhiko/redis-rs
    https://github.com/rust-lang/cargo
    https://github.com/rust-lang/rust
    https://github.com/tokio-rs/tokio
)

OPEN_SOURCE_SASS_REPOS=(
    https://github.com/jgthms/bulma
)

OPEN_SOURCE_SCALA_REPOS=(
    https://github.com/RedisLabs/spark-redis
    https://github.com/apache/spark
    https://github.com/prisma/prisma
)

OPEN_SOURCE_SHELL_REPOS=(
    https://github.com/Bash-it/bash-it
    https://github.com/Netflix/dispatch-docker
    https://github.com/acmesh-official/acme.sh
    https://github.com/alpinelinux/alpine-chroot-install
    https://github.com/asdf-vm/asdf
    https://github.com/graphql/graphql-spec
    https://github.com/iredmail/iRedMail
    https://github.com/kubernetes-sigs/kubespray
    https://github.com/nginx-proxy/docker-letsencrypt-nginx-proxy-companion
    https://github.com/nginx-proxy/nginx-proxy
    https://github.com/nvm-sh/nvm
    https://github.com/oh-my-fish/oh-my-fish
    https://github.com/ohmyzsh/ohmyzsh
    https://github.com/paoloantinori/hhighlighter
    https://github.com/pyenv/pyenv
    https://github.com/rupa/z
    https://github.com/sindresorhus/pure
    https://github.com/spinnaker/spinnaker
    https://github.com/wmnnd/nginx-certbot
)

OPEN_SOURCE_SWIFT_REPOS=(
    https://github.com/sindresorhus/Gifski
)

OPEN_SOURCE_TYPESCRIPT_REPOS=(
    https://github.com/APIs-guru/graphql-lodash
    https://github.com/APIs-guru/graphql-voyager
    https://github.com/FormidableLabs/urql
    https://github.com/angular/angular
    https://github.com/ant-design/ant-design
    https://github.com/ant-design/ant-design-pro
    https://github.com/ant-design/ant-motion
    https://github.com/apollographql/apollo
    https://github.com/apollographql/apollo-client
    https://github.com/apollographql/apollo-server
    https://github.com/apollographql/graphql-tools
    https://github.com/apollographql/react-apollo
    https://github.com/botpress/botpress
    https://github.com/devhubapp/devhub
    https://github.com/dotansimha/graphql-code-generator
    https://github.com/elastic/kibana
    https://github.com/graphql-editor/graphql-editor
    https://github.com/graphql/graphiql
    https://github.com/graphql/graphql-js
    https://github.com/howtographql/howtographql
    https://github.com/imolorhe/altair
    https://github.com/ionic-team/ionic
    https://github.com/kriasoft/nodejs-api-starter
    https://github.com/learnapollo/learnapollo
    https://github.com/microsoft/TypeScript
    https://github.com/mrdoob/three.js
    https://github.com/percona/grafana-dashboards
    https://github.com/prisma-labs/graphql-playground
    https://github.com/pubkey/rxdb
    https://github.com/quicktype/quicktype
    https://github.com/sindresorhus/got
    https://github.com/sindresorhus/is
    https://github.com/sindresorhus/p-queue
    https://github.com/sindresorhus/refined-github
    https://github.com/teambit/bit
    https://github.com/typeorm/typeorm
    https://github.com/typicode/husky
)

OPEN_SOURCE_VIMSCRIPT_REPOS=(
    https://github.com/VundleVim/Vundle.vim
    https://github.com/christoomey/vim-tmux-navigator
)

clone-opensource() {
    oldpwd=$(pwd)
    mkdir -p "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR"
    cd "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_ALGORITHMS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_BOOKS_REPOS_DIR"
    cd "$OPEN_SOURCE_BOOKS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_BOOKS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_C_REPOS_DIR"
    cd "$OPEN_SOURCE_C_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_C_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_CPP_REPOS_DIR"
    cd "$OPEN_SOURCE_CPP_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_CPP_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_DART_REPOS_DIR"
    cd "$OPEN_SOURCE_DART_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_DART_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR"
    cd "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_DOCKERFILE_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_DOCS_REPOS_DIR"
    cd "$OPEN_SOURCE_DOCS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_DOCS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_ELIXIR_REPOS_DIR"
    cd "$OPEN_SOURCE_ELIXIR_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_ELIXIR_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_ERLANG_REPOS_DIR"
    cd "$OPEN_SOURCE_ERLANG_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_ERLANG_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_GO_REPOS_DIR"
    cd "$OPEN_SOURCE_GO_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_GO_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_HASKELL_REPOS_DIR"
    cd "$OPEN_SOURCE_HASKELL_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_HASKELL_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_JAVA_REPOS_DIR"
    cd "$OPEN_SOURCE_JAVA_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_JAVA_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR"
    cd "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_JAVASCRIPT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_JULIA_REPOS_DIR"
    cd "$OPEN_SOURCE_JULIA_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_JULIA_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_JUPYTER_REPOS_DIR"
    cd "$OPEN_SOURCE_JUPYTER_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_JUPYTER_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_KOTLIN_REPOS_DIR"
    cd "$OPEN_SOURCE_KOTLIN_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_KOTLIN_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_LUA_REPOS_DIR"
    cd "$OPEN_SOURCE_LUA_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_LUA_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_PYTHON_REPOS_DIR"
    cd "$OPEN_SOURCE_PYTHON_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_PYTHON_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR"
    cd "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_PYTHON_ASYNC_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_RUBY_REPOS_DIR"
    cd "$OPEN_SOURCE_RUBY_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_RUBY_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_RUST_REPOS_DIR"
    cd "$OPEN_SOURCE_RUST_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_RUST_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SASS_REPOS_DIR"
    cd "$OPEN_SOURCE_SASS_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SASS_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SCALA_REPOS_DIR"
    cd "$OPEN_SOURCE_SCALA_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SCALA_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SHELL_REPOS_DIR"
    cd "$OPEN_SOURCE_SHELL_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SHELL_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_SWIFT_REPOS_DIR"
    cd "$OPEN_SOURCE_SWIFT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_SWIFT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR"
    cd "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_TYPESCRIPT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    mkdir -p "$OPEN_SOURCE_VIMSCRIPT_REPOS_DIR"
    cd "$OPEN_SOURCE_VIMSCRIPT_REPOS_DIR" || return 1
    for repo in "${OPEN_SOURCE_VIMSCRIPT_REPOS[@]}"; do
        git clone --recursive $repo
    done
    cd "$oldpwd"
}

[[ -d "$REPOS_DIR" ]] && repos() { cd "$REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR" ]] && opensource-algorithms-repos() { cd "$OPEN_SOURCE_ALGORITHMS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_BOOKS_REPOS_DIR" ]] && opensource-books-repos() { cd "$OPEN_SOURCE_BOOKS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_C_REPOS_DIR" ]] && opensource-c-repos() { cd "$OPEN_SOURCE_C_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_CPP_REPOS_DIR" ]] && opensource-cpp-repos() { cd "$OPEN_SOURCE_CPP_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_DART_REPOS_DIR" ]] && opensource-dart-repos() { cd "$OPEN_SOURCE_DART_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR" ]] && opensource-dockerfile-repos() { cd "$OPEN_SOURCE_DOCKERFILE_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_DOCS_REPOS_DIR" ]] && opensource-docs-repos() { cd "$OPEN_SOURCE_DOCS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_ELIXIR_REPOS_DIR" ]] && opensource-elixir-repos() { cd "$OPEN_SOURCE_ELIXIR_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_ERLANG_REPOS_DIR" ]] && opensource-erlang-repos() { cd "$OPEN_SOURCE_ERLANG_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_GO_REPOS_DIR" ]] && opensource-go-repos() { cd "$OPEN_SOURCE_GO_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_HASKELL_REPOS_DIR" ]] && opensource-haskell-repos() { cd "$OPEN_SOURCE_HASKELL_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_JAVA_REPOS_DIR" ]] && opensource-java-repos() { cd "$OPEN_SOURCE_JAVA_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR" ]] && opensource-javascript-repos() { cd "$OPEN_SOURCE_JAVASCRIPT_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_JULIA_REPOS_DIR" ]] && opensource-julia-repos() { cd "$OPEN_SOURCE_JULIA_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_JUPYTER_REPOS_DIR" ]] && opensource-jupyter-repos() { cd "$OPEN_SOURCE_JUPYTER_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_KOTLIN_REPOS_DIR" ]] && opensource-kotlin-repos() { cd "$OPEN_SOURCE_KOTLIN_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_LUA_REPOS_DIR" ]] && opensource-lua-repos() { cd "$OPEN_SOURCE_LUA_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_PYTHON_REPOS_DIR" ]] && opensource-python-repos() { cd "$OPEN_SOURCE_PYTHON_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR" ]] && opensource-python-async-repos() { cd "$OPEN_SOURCE_PYTHON_ASYNC_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_RUBY_REPOS_DIR" ]] && opensource-ruby-repos() { cd "$OPEN_SOURCE_RUBY_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_RUST_REPOS_DIR" ]] && opensource-rust-repos() { cd "$OPEN_SOURCE_RUST_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SASS_REPOS_DIR" ]] && opensource-sass-repos() { cd "$OPEN_SOURCE_SASS_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SCALA_REPOS_DIR" ]] && opensource-scala-repos() { cd "$OPEN_SOURCE_SCALA_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SHELL_REPOS_DIR" ]] && opensource-shell-repos() { cd "$OPEN_SOURCE_SHELL_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_SWIFT_REPOS_DIR" ]] && opensource-swift-repos() { cd "$OPEN_SOURCE_SWIFT_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR" ]] && opensource-typescript-repos() { cd "$OPEN_SOURCE_TYPESCRIPT_REPOS_DIR"; }
[[ -d "$OPEN_SOURCE_VIMSCRIPT_REPOS_DIR" ]] && opensource-vimscript-repos() { cd "$OPEN_SOURCE_VIMSCRIPT_REPOS_DIR"; }
