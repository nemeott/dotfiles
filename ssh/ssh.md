Generate a key and copy it to the other machine.

```bash
$ ssh-keygen -t ed25519 -f ~/.ssh/another-machine
$ ssh-copy-id -i ~/.ssh/another-machine user@another-machine
```

By using:

```nix
programs.ssh.startAgent = true;
```

in your Nix configuration, you can store the private key identity in the ssh agent. To add the key to the agent, run:

```bash
$ ssh-add ~/.ssh/another-machine
```
