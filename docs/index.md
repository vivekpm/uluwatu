*Uluwatu is situated at the southern end of Bali and is the island most famous and consistent wave. The spot offers several waves which are working with different swells and tides.*

*Uluwatu is a web UI for Cloudbreak - a cloud agnostic Hadoop as a Service API.*

##[Cloudbreak UI](https://cloudbreak.sequenceiq.com/)

When we have started to work on Cloudbreak, our main goal was to create an easy to use, cloud and Hadoop distribution agnostic Hadoop as a Service API. Though we always like to automate everything and approach things with a very DevOps mindset, as a side project we have created a UI for Cloudbreak as well.
The goal of the UI is to ease to process and allow you to create a Hadoop cluster on your favourite cloud provider in `one-click`.

The UI is built on the foundation of the Cloudbreak REST API. You can access our hosted version [here](https://cloudbreak.sequenceiq.com/).

###Manage credentials

Using manage credentials you can link your cloud account with the Cloudbreak account and define the keys for accessing to the created resources.


###Manage blueprints

Blueprints are your declarative definition of a Hadoop cluster.


###Manage resources

Using manage resources you can create custom templates for provider specific instances.


###Manage networks

Via network management you can easily configure the subnet, network id(in case of openstack) of the newly provisioned virtual network or use an existing virtual network.


###Manage security groups

Security groups are able to manage a set of security rule that could open ports on the specified protocol and subnet. 


###Create cluster
Using the create cluster functionality you will create a cloud Stack and a Hadoop Cluster. In order to create a cluster you will have to select a credential first.
_Note: Cloudbreak can maintain multiple cloud credentials (even for the same provider)._

Once you have launched the cluster creation you can track the progress either on Cloudbreak UI or your cloud provider management UI.

_Note: Because Azure does not directly support third party public images we will have to copy the used image from VM Depot into your storage account. This process will take 20 minutes so be patient - but this step will have to be done only once._

##Technical details

Uluwatu is a small [node.js](http://nodejs.org/) webapp with an [Angular.js](https://angularjs.org/) frontend. The main logic is on the client side, the node backend has only the following reposibilities:

- provides an HTTP server that serves the static HTML/JS/CSS content
- proxies every request coming from the Angular side to Cloudbreak therefore eliminating the need for [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
- obtains an OAuth2 token from an identity server to Cloudbreak by handling the authorization code flow

####Browser compatibility
- Internet Explorer 10 or newer
- Chrome 32 or newer
- Safari 6 or newer
- Firefox 24 or newer

###Running Uluwatu locally for development

If you'd like to run Uluwatu on your local machine, you should have npm and node.js installed. After checking out the git repository, run `npm install` in Uluwatu's directory and set these environment variables:
If you using the [cloudbreak-deployer](https://github.com/sequenceiq/cloudbreak-deployer) and you started with `cbd start` then the uluwatu container is running and the name is `cbreak_uluwatu_1` so you have to remove it with `docker rm -f cbreak_uluwatu_1`.
After that you have to start an ambassador container with this command:

```
docker run -d -p 3000:3000 -e PORT=3000 -e SERVICE_NAME=uluwatu --name local_uluwatu_ambassador sequenceiq/ambassadord 192.168.59.3:3000
```
> NOTE: Ambassador supports static forwards, DNS-based forwards (with SRV), Consul+Etcd based forwards, or forwards based on the connecting container's intended backend.

Now you can start the local uluwatu just set some environment variable:

```
ULU_CLOUDBREAK_ADDRESS=http://192.168.59.103:8080
ULU_PERISCOPE_ADDRESS=http://192.168.59.103:8085
ULU_IDENTITY_ADDRESS=http://192.168.59.103:8089
ULU_OAUTH_CLIENT_ID=uluwatu
ULU_IDENTITY_PORT=443
ULU_SULTANS_ADDRESS=http://192.168.59.103:3001
ULU_HOST_ADDRESS=http://192.168.59.103:3000
ULU_OAUTH_CLIENT_SECRET=cbsecret2015
ULU_OAUTH_REDIRECT_URI=http://192.168.59.103:3000/authorize
NODE_TLS_REJECT_UNAUTHORIZED=0
```
If the environment variables are set, simply run `node server.js`

When you create a pull request please format your code with the `format.sh` script.

###Running Uluwatu in Docker

If you'd like to deploy a stable version of Uluwatu somewhere, we recommend to use its Docker image (that's how we do it in production) so it's not needed to have node installed on the server. This image grabs the latest release from the Github repo and starts the node server. The environment variables should be provided like above.
```
docker run -d --name uluwatu \
 -e "ULU_CLOUDBREAK_ADDRESS=$ULU_CLOUDBREAK_ADDRESS" \
 -e "ULU_PERISCOPE_ADDRESS=$ULU_PERISCOPE_ADDRESS" \
 -e "ULU_SULTANS_ADDRESS=$ULU_SULTANS_ADDRESS" \
 -e "ULU_IDENTITY_ADDRESS=$ULU_IDENTITY_ADDRESS" \
 -e "ULU_OAUTH_CLIENT_ID=$ULU_OAUTH_CLIENT_ID" \
 -e "ULU_OAUTH_CLIENT_SECRET=$ULU_OAUTH_CLIENT_SECRET" \
 -e "ULU_HOST_ADDRESS=$ULU_HOST_ADDRESS" \
 -p 3000:3000 sequenceiq/uluwatu
 ```

<!--ui.md-->
