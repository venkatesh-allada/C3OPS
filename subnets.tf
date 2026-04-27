# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnets.public[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-${count.index + 1}"
  }
}

# Web Subnets (Private)
resource "aws_subnet" "web" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.subnets.web[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-web-${count.index + 1}"
  }
}

# App Subnets (Private)
resource "aws_subnet" "app" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.subnets.app[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-app-${count.index + 1}"
  }
}

# DB Subnets (Private)
resource "aws_subnet" "db" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.subnets.db[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# Private Route Table (Using NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "web" {
  count          = 2
  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app" {
  count          = 2
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  count          = 2
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private.id
}