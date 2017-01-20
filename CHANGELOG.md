4.5.1 (01/19/2016)
==================

* Fix `ActiveRecord#associations` for Rails 4

4.5.0 (01/19/2016)
==================

* Fix `ActiveRecord#associations` to use LIMIT 1 for has_many associations
* Remove redundant `ActiveRecord.latest`

4.4.2 (01/10/2016)
==================

* Fix glaring bug in Duck class where the `:only` option is ignored (since 4.4.0)

4.4.1 (12/19/2016)
==================

* Lazy load the rubygems/dependency_installer only when `require!` is called

4.4.0 (12/4/2016)
=================

* Target objects are no longer extended with the [Usable](https://github.com/ridiculous/usable) module

4.3.0 (10/10/2016)
==================

* Fix issue with not being able to punch the same duck with different options
* Add the `:target` option to `.call` to override the receiving class
