.PHONY: clean setup user-perms rmq-perms

down:
	docker compose down

rmq-perms:
	sudo chown -R 999:999 mnesia

user-perms:
	sudo chown -R "$(USER):$(USER)" .

clean: user-perms
	rm -vrf $(CURDIR)/mnesia/*/rabbit*

setup: rmq-perms
