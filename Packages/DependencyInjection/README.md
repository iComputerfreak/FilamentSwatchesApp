#  DependencyInjection

This package contains an abstraction of Swinject to inject dependencies into the application.

You can use the `DependencyContext` to register and resolve dependencies.  
Additionally, the `@Injected` property wrapper can make resolving dependencies easier.

The intent of this package is to provide a simple abstraction layer between the app and the actual dependency injection framework to allow for easy replacement of the latter.
