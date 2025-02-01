class_name Only

static var __watched: TDTest
static var __only_tree = []

static func watch(test_file: TDTest):
  __watched = test_file

static func __append(node):
  # deeper nodes get precedent over their parents.
  # since child nodes are constructed first in test trees,
  # we check if the "only tree" contains children of the current node
  # and don't need to worry about pruning parent nodes.
  if is_instance_of(node, TDTestGroup) and __contains_child_of(node):
    return
  
  __only_tree.append(node)

static func __contains_child_of(node):
  if is_instance_of(node, TDTestCase):
    return false

  for child in node.value:
    if __only_tree.find(child) >= 0:
      return true
    elif __contains_child_of(child):
      return true

  return false

static func group(description: String, fn: Callable=func(): pass):
  __append(__watched.group(description, fn))

static func test(description: String, fn: Callable=func(): pass):
  __append(__watched.test(description, fn))

static func contains_tests():
  return __only_tree and __only_tree.size() > 0

static func __reconstruct():
  var reconstructed = []
  
  while __only_tree.size():
    var partial = __only_tree.pop_front()
    var parent = partial.parent
    var remade_tree = partial

    while parent:
      remade_tree.link_parent(TDTestGroup.from(partial.parent))
      remade_tree = remade_tree.parent
      partial = parent
      parent = parent.parent
    
    reconstructed.append(remade_tree)
  
  return reconstructed

static func __merge(reconstructed):
  var merged = []
  while reconstructed.size():
    var base = reconstructed.pop_front()

    var same_root = []
    var list = reconstructed.duplicate()
    for item in list:
      if item.description == base.description:
        same_root.append(item)
        reconstructed.remove_at(reconstructed.find(item))
    
    for prospect in same_root:
      __merge_subtrees(base, prospect)

    merged.append(base)
  return merged

static func __merge_subtrees(base_tree, prospect_tree):
  if is_instance_of(base_tree, TDTestCase) or is_instance_of(prospect_tree, TDTestCase):
    return
  
  for subtree in prospect_tree.value:
    var found = base_tree.value.filter(func (node): return node.description == subtree.description)
    if found.size():
      __merge_subtrees(found.front(), subtree)
    else:
      subtree.link_parent(base_tree)

static func evaluate():
  __only_tree = __reconstruct()
  __only_tree = __merge(__only_tree)
  for test in __only_tree:
    await test.evaluate()
  
static func report_results():
  for test in __only_tree:
    TDLogger.log()
    test.report_result()

static func passed():
  return __only_tree.all(func(t): return t != null && t.passing)
