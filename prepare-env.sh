#!/bin/bash
npm config set cache $PWD/.npm --global
apt-get install sudo
echo "root ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/docker && chmod 0440 /etc/sudoers.d/docker
export GOROOT=/goroot
export GOPATH=$CI_PROJECT_DIR/gopath/
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
cd $GOPATH/src/github.com/FabLabBerlin/localmachines
echo "Waiting for MySQL." && sleep 10
sed -e "s/mysqlhost = localhost/mysqlhost = mysql/g" tests/conf/app.example.conf > tests/conf/app.conf
mysql --user=root --host=mysql --password="$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < fabsmith_template.sql
glide install
go get github.com/FabLabBerlin/easylab-lib
go get github.com/FabLabBerlin/easylab-gw
go get github.com/astaxie/beego
go get github.com/go-sql-driver/mysql
go get github.com/lib/pq
go get github.com/smartystreets/goconvey/convey
ln -sfn $GOPATH/src/github.com/FabLabBerlin/easylab-gw $CI_PROJECT_DIR/../easylab-gw
ln -sfn $GOPATH/src/github.com/FabLabBerlin/easylab-lib $CI_PROJECT_DIR/../easylab-lib
ls -l $GOPATH/src/github.com/FabLabBerlin/
cd $GOPATH/src/github.com/FabLabBerlin/localmachines/clients/admin
npm install
bower install --allow-root
cd $GOPATH/src/github.com/FabLabBerlin/localmachines/clients/machines
npm install
cd $GOPATH/src/github.com/FabLabBerlin/localmachines/clients/signup
npm install
bower install --allow-root
grunt prod
echo PATH: $PATH
echo GOPATH: $GOPATH
