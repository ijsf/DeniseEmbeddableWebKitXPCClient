# EmbeddableWebKitXPCClient

This is a super lightweight Swift macOS app that embeds a partially functioning WebKit browser but does not include any browser code in its binary.

The browser functionality is provided by connecting to a local XPC service provided by the DeniseEmbeddableWebKitDaemon and serves as a proof of oncept on how to use an embedded browser in a (constrained) application without actually embedding the browser itself in the binary.

This proof of concept was made for a prototype that is no longer functioning, the code is therefore open source. This repository is currently unmaintained.

---

In order to run DeniseApp, make sure the DeniseServerLaunchDaemon project has been built successfully and its daemon has been successfully installed and is running on your computer.
