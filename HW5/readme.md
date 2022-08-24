# Дамашнее задание 5

## Олег Дьяченко DEVOPS-22

#### Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

    $ git show aefea
    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400
    Update CHANGELOG.md

#### Какому тегу соответствует коммит 85024d3?

    $ git show 85024d3
    commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

#### Сколько родителей у коммита b8d720? Напишите их хеши.
    
    9ea88f22fc
    56cd7859e0

    $ git log b8d720 --oneline --graph
    *   b8d720f834 Merge pull request #23916 from hashicorp/cgriggs01-stable
    |\
    | * 9ea88f22fc add/update community provider listings
    |/
    *   56cd7859e0 Merge pull request #23857 from hashicorp/cgriggs01-stable

#### Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

    $ git log v0.12.23..v0.12.24 --oneline
    33ff1c03bb (tag: v0.12.24) v0.12.24
    b14b74c493 [Website] vmc provider links
    3f235065b9 Update CHANGELOG.md
    6ae64e247b registry: Fix panic when server is unreachable
    5c619ca1ba website: Remove links to the getting started guide's old location
    06275647e2 Update CHANGELOG.md
    d5f9411f51 command: Fix bug when using terraform login on Windows
    4b6d06cc5d Update CHANGELOG.md
    dd01a35078 Update CHANGELOG.md
    225466bc3e Cleanup after v0.12.23 release

#### Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

    $ git log -S'func providerSource' --oneline
    5af1e6234a main: Honor explicit provider_installation CLI config when present
    8c928e8358 main: Consult local directories as potential mirrors of providers

Первый раз появилась функция
    
    $ git grep 'func providerSource' 8c928e8358
    8c928e8358:provider_source.go:func providerSource(services *disco.Disco) getproviders.Source {

Добавился новый параметр
    
    $ git grep 'func providerSource' 5af1e6234a
    5af1e6234a:provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {

#### Найдите все коммиты в которых была изменена функция globalPluginDirs.

    $ git grep 'func globalPluginDirs'
    plugins.go:func globalPluginDirs() []string {

    $ git log -L :globalPluginDirs:plugins.go --no-patch --oneline
    78b1220558 Remove config.go and update things using its aliases
    52dbf94834 keep .terraform.d/plugins for discovery
    41ab0aef7a Add missing OS_ARCH dir to global plugin paths
    66ebff90cd move some more plugin search path logic to command
    8364383c35 Push plugin discovery down into command package

#### Кто автор функции synchronizedWriters?

    $ git log -S'func synchronizedWriters' --pretty=format:'%h - %an %ae'
    bdfea50cc8 - James Bardin j.bardin@gmail.com
    5ac311e2a9 - Martin Atkins mart@degeneration.co.uk

мартин добавил, а Джеймс удалил.

    $ git grep 'func synchronizedWriters' 5ac311e2a9
    5ac311e2a9:synchronized_writers.go:func synchronizedWriters(targets ...io.Writer) []io.Writer {



