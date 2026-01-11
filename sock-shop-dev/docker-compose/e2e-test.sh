#!/usr/bin/env bash
set -euo pipefail

BASE_URL="http://localhost:8082"
COOKIE_JAR="cookies.txt"

ITEM_ID="3395a43e-2d88-40de-b95f-e00e1502085b"

echo "== Register =="
# Capture both body and HTTP status
RESP=$(curl -s -c "$COOKIE_JAR" -w "\n%{http_code}" \
  -H "Content-Type: application/json" \
  -d '{"username":"e2e","password":"e2e"}' \
  "$BASE_URL/register")

# Split body and status
BODY=$(echo "$RESP" | head -n -1)
STATUS=$(echo "$RESP" | tail -n1)

echo "HTTP status = $STATUS"
echo "Body = $BODY"

echo "== Login =="
curl -s -b $COOKIE_JAR -c $COOKIE_JAR \
  -H "Authorization: Basic ZTJlOmUyZQ==" \
  "$BASE_URL/login"
echo " "
echo "== Add item to cart =="
curl -sf -b $COOKIE_JAR \
  -H "Content-Type: application/json" \
  -d "{\"id\":\"$ITEM_ID\"}" \
  "$BASE_URL/cart"
echo " "
echo "== Update cart item (quantity=2) =="
curl -sf -b $COOKIE_JAR \
  -H "Content-Type: application/json" \
  -d "{\"id\":\"$ITEM_ID\",\"quantity\":2}" \
  "$BASE_URL/cart/update"

echo "== Get cart =="
CART=$(curl -s -b $COOKIE_JAR "$BASE_URL/cart")
echo "$CART" | jq .

CART_ITEM_ID=$(echo "$CART" | jq -r '.[0].itemId')

echo "== Delete cart item =="
curl -s -o /dev/null -w "%{http_code}" \
  -b "$COOKIE_JAR" -X DELETE \
  "$BASE_URL/cart/$CART_ITEM_ID"
echo " "
echo "== Cart should be empty =="
curl -s -b $COOKIE_JAR "$BASE_URL/cart" | jq .

echo "== Add item again =="
curl -sf -b $COOKIE_JAR \
  -H "Content-Type: application/json" \
  -d "{\"id\":\"$ITEM_ID\"}" \
  "$BASE_URL/cart"

echo "== Create address =="
curl -sf -b $COOKIE_JAR \
  -H "Content-Type: application/json" \
  -d '{"street":"Test St","city":"Berlin","country":"DE"}' \
  "$BASE_URL/addresses"

echo "== Create card =="
curl -sf -b $COOKIE_JAR \
  -H "Content-Type: application/json" \
  -d '{"longNum":"4111111111111111","expires":"12/30"}' \
  "$BASE_URL/cards"

echo "== Create order =="
curl -sf -b $COOKIE_JAR -X POST \
  "$BASE_URL/orders" | jq .

echo "== Get orders =="
curl -s -b $COOKIE_JAR "$BASE_URL/orders" | jq .

echo "== Delete cart (post-order cleanup) =="
curl -sf -b $COOKIE_JAR -X DELETE \
  "$BASE_URL/cart"

echo "== Final cart state =="
curl -s -b $COOKIE_JAR "$BASE_URL/cart" | jq .

echo " FULL E2E PIPELINE PASSED "
