---
toc: false
theme: [dashboard]
---

# [2024/46] 🌐 ISO Codes

This week we're exploring the ISO 3166 standard! The data this week comes from the `{ISOcodes}` [R package](https://cran.r-project.org/web/packages/ISOcodes/index.html). This is a simple page that allows you to filter the three-letter ISO country codes by their first, second, and third letters. This flowchart is created using the Observable Plot [tree mark](https://observablehq.com/plot/marks/tree).

```js
const codes = FileAttachment("data/iso_codes.json").json({typed: true})
```

```js
const one = aq.from(codes).dedupe("one").array("one").sort()
```

```js
const codesOne = oneInput ? aq.from(codes).filter(aq.escape((d) => d.one === oneInput)) : aq.from(codes)
```

```js
const two = codesOne.dedupe("two").array("two").sort()
```

```js
const codesTwo = twoInput ? codesOne.filter(aq.escape((d) => d.two === twoInput)) : codesOne
```

```js
const three = codesTwo.dedupe("three").array("three").sort()
```

```js
const codesThree = threeInput ? codesTwo.filter(aq.escape((d) => d.three === threeInput)) : codesTwo
```

<hr>

<div class="grid grid-cols-4" style="grid-auto-rows: auto;">

<div class="card grid-colspan-1">

## Use this panel to filter the 3-letter country code by its first, second, or third letter.

```js
const oneInput = view(Inputs.select(one.length == 1 ? one : [null, ...one], {label: "First Letter"}))
```

```js
const twoInput = view(Inputs.select(two.length == 1 ? two : [null, ...two], {label: "Second Letter"}))
```

```js
const threeInput = view(Inputs.select(three.length == 1 ? three : [null, ...three], {label: "Third Letter"}))
```

</div>

<div class="grid-colspan-3">

${resize((width) => Plot.plot({
  width,
  axis: null,
  height: codesThree.numRows()*15,
  margin: 10,
  marginLeft: 40,
  marginRight: 150,
  marks: [
    Plot.tree(codesThree, {path: "alpha3", textStroke: "black"})
  ]
}))}

</div>

</div>