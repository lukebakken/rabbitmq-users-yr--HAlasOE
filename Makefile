.PHONY: clean down setup user-perms rmq-perms up

up: rmq-perms
	docker compose up

down:
	docker compose down

rmq-perms:
	sudo chown -R 999:999 mnesia

user-perms:
	sudo chown -R "$(USER):$(USER)" .

clean: user-perms
	rm -vrf $(CURDIR)/mnesia/*/rabbit*
	mv -f rmq0.conf.bak rmq0.conf
	mv -f rmq1.conf.bak rmq1.conf
	mv -f rmq2.conf.bak rmq2.conf

setup: rmq-perms
