<meta charset="utf-8"/>
	<title>Your Groccery Store</title>
	<meta name="viewport" content="width=device-width"/>
	<meta name="description" content=""/>
	<meta name="author" content=""/>
	<link href="//cdn.ubc.ca/clf/7.0.5/css/ubc-clf-full.min.css" rel="stylesheet"/>
	<link href="css/unit.css" rel="stylesheet"/>
	<script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
	</head> 
	<routing />
	<body class="full-width full-width-left">
		<div id="unit" class="row-fluid expand">
		  <div class="container">
			  <div class="span12">
				  <div class="navbar">
					  <a class="btn btn-navbar" data-toggle="collapse" data-target="#unit-navigation">
						  <span class="icon-bar"></span>
						  <span class="icon-bar"></span>
						  <span class="icon-bar"></span>
					  </a>
				  </div>
				  <div id="unit-name">
					  <a href="/shop/index.jsp"><span id="unit-faculty">Your Supermart</span><span id="unit-identifier"></span></a>
				  </div>
			  </div>
		</div>
		</div>

		<div id="unit-menu" class="navbar expand" role="navigation">
			<div class="navbar-inner expand">
				<div class="container">
					<div class="nav-collapse collapse" id="unit-navigation">
						<ul class="nav">
							<li><a href="/shop/index.jsp">Home</a></li>
							<li><a href="/shop/listprod.jsp">Products</a></li>
							<li><a href='/shop/listorder.jsp'>Order List</a></li>
							<li><a href="/shop/showcart.jsp">Cart</a></li>
									</ul>
									<h3 style="text-align: end; color: white;"><% out.println(session.getAttribute("authenticatedUser") == null ? "" : (String) session.getAttribute("authenticatedUser")); %></h3>
							</div>
								</div> 
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
</head>