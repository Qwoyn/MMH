# MMH Multiclass/Multicontract Hybrid

## NFT and MCT interaction 

"It is fair to think of MCTs as a hybrid of fungible tokens (FT) and non-fungible tokens (NFTs), that is tokens are 
fungible within the same class but non-fungible with that from a different class." - EIP1203 

Let's use this concept to create a smart contract that allows a user to send MCT Tokens to an NFT smart contract. In 
this example we will use the the Abilities Contract construct wood and iron within the MCT Craftable item generator and use 
those items in the NFT Tool Generator Contract to craft a pickaxe. In order for this to happen, we must include the 
functions in the contract that is making the call as required by the contracts ABI that I am calling.  the Abilities Contract 
will include the ABI function calls and the addresses from the Tool Generator Contract and the Craftable Item Generator.

### MCT Tokens


					NFT Class One					NFT Class Two
					----							----
					   |							   |
					   FT Tokens of 					FT Tokens of
					   Class One						Class Two
					   
					   

## Contracts

### NFT Abilities Contract
	- Allows user to Call Craftable Item Generator and craft items
	- Allows user to Call Tool Generator and craft items
	- Creates record of tool generation and sends record token to owner
	
	
### NFT Tool Generator Contract
	- NFT Contract that crafts items using MCT Token
		- 	if user sends 1 Iron and 2 Wood tokens
			the contract will create 1 pickaxe token.
		
		- 	Once the tokens have been used to generate the
			tool, those tokens will be destroyed.
		
		
### MCT Craftable Item Generator Contract
	- MCT contract that creates craftable items
		-	user will create 1 Iron token and 2 Wood tokens
			and send those tokens to NFT Tool Creator Contract

	- Iron NFT Attributes
		- grey
		- 7 on the common scale
		- hard
			-FT Attributes within Class One
				- 1 gram
				- value 50
				- 1000 Exist
	
	- Wood NFT Attributes
		- brown
		- 1 on the common scale
		- hard
			- -FT Attributes within Class Two
				- 1 gram
				- value 25
				- 2000 exist